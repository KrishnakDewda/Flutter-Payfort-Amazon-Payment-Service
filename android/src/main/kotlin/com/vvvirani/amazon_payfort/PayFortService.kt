package com.vvvirani.amazon_payfort

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log

import com.payfort.fortpaymentsdk.FortSdk
import com.payfort.fortpaymentsdk.callbacks.FortCallBackManager
import com.payfort.fortpaymentsdk.callbacks.FortInterfaces
import com.payfort.fortpaymentsdk.domain.model.FortRequest
import com.payfort.fortpaymentsdk.exceptions.FortException
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class PayFortService : Activity() {

    private var tag = this.javaClass.simpleName

    private var fortCallback: FortCallBackManager? = null

    override fun onResume() {
        super.onResume()
        initService()
    }

    companion object {

        private var instance: PayFortService? = null

        fun getInstance(): PayFortService? {
            return instance
        }
    }

    interface PayFortResultHandler {
        fun onResult(fortResult: MutableMap<String, Any?>)
    }

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        initService()
    }


    private fun initService() {
        instance = this
        if (fortCallback == null) {
            fortCallback = FortCallBackManager.Factory.create()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        fortCallback?.onActivityResult(requestCode, resultCode, data)
    }

    fun processingTransaction(
        environment: String?,
        fortRequest: FortRequest,
        result: PayFortResultHandler,
    ) {
        try {
            FortSdk.getInstance().registerCallback(
                this,
                fortRequest,
                getEnvironment(environment), 5,
                fortCallback,
                true,
                object : FortInterfaces.OnTnxProcessed {
                    override fun onSuccess(
                        requestDic: MutableMap<String, Any>?,
                        responeDic: MutableMap<String, Any>?,
                    ) {
                        Log.d(tag, "onSuccess : $requestDic $responeDic")

                        val response: MutableMap<String, Any?> = HashMap()
                        response["response_status"] = 0
                        response["response_code"] = responeDic?.get("response_code")
                        response["response_message"] = responeDic?.get("response_message")
                        result.onResult(response)
                    }

                    override fun onFailure(
                        requestDic: MutableMap<String, Any>?,
                        responeDic: MutableMap<String, Any>?,
                    ) {
                        Log.d(tag, "onFailure : $requestDic $responeDic")

                        val response: MutableMap<String, Any?> = HashMap()
                        response["response_status"] = 2
                        response["response_code"] = responeDic?.get("response_code")
                        response["response_message"] = responeDic?.get("response_message")
                        result.onResult(response)
                    }

                    override fun onCancel(
                        requestDic: MutableMap<String, Any>?,
                        responeDic: MutableMap<String, Any>?,
                    ) {
                        Log.d(tag, "onCancel : $requestDic $responeDic")

                        val response: MutableMap<String, Any?> = HashMap()
                        response["response_status"] = 1
                        response["response_code"] = responeDic?.get("response_code")
                        response["response_message"] = responeDic?.get("response_message")
                        result.onResult(response)
                    }
                },
            )
        } catch (e: FortException) {
            Log.d(tag, "FortException : ${e.code}, ${e.message}")
        }
    }

    private fun getEnvironment(environment: String?): String {
        return when (environment) {
            "test" -> {
                FortSdk.ENVIRONMENT.TEST
            }
            "production" -> {
                FortSdk.ENVIRONMENT.PRODUCTION
            }
            else -> ""
        }
    }

    fun getEnvironmentBaseUrl(env: String): String {
        return when (env) {
            "test" -> {
                "https://sbpaymentservices.payfort.com/FortAPI/paymentApi"
            }
            "production" -> {
                "https://paymentservices.payfort.com/FortAPI/paymentApi"
            }
            else -> ""
        }
    }

    fun createSignature(shaType: String, concatenatedString: String): String {
        try {
            val bytes = concatenatedString.toByteArray()
            val md = MessageDigest.getInstance(shaType)
            val digest = md.digest(bytes)
            return digest.fold("", { str, it -> str + "%02x".format(it) })
        } catch (e: NoSuchAlgorithmException) {
            Log.d("Signature Error", e.toString())
        }
        return ""
    }

}