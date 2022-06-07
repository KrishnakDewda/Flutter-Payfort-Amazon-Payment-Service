package com.vvvirani.amazon_payfort

import android.app.Activity
import android.content.Context

import androidx.annotation.NonNull
import com.payfort.fortpaymentsdk.FortSdk
import com.payfort.fortpaymentsdk.domain.model.FortRequest

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.util.HashMap

class AmazonPayfortPlugin : FlutterPlugin,
    MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel

    private lateinit var context: Context
    private lateinit var activity: Activity

    private var fortRequest = FortRequest()
    private var service: PayFortService? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger,
            "vvvirani/amazon_payfort")
        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                service = PayFortService.getInstance()
            }
            "getEnvironmentBaseUrl" -> {
                val envType = call.argument<String>("envType")
                val environment = envType?.let { service?.getEnvironmentBaseUrl(it) }
                result.success(environment)
            }
            "getDeviceId" -> {
                val deviceId = FortSdk.getDeviceId(activity)
                result.success(deviceId)
            }
            "generateSignature" -> {
                val shaType = call.argument<String>("shaType")
                val concatenatedString = call.argument<String>("concatenatedString")
                val signature =
                    shaType?.let {
                        concatenatedString?.let { it1 ->
                            service?.createSignature(it,
                                it1)
                        }
                    }
                result.success(signature)
            }
            "processingTransaction" -> {
                if (service == null) {
                    service = PayFortService.getInstance()
                }
                val envType = call.argument<String>("envType")

                fortRequest.requestMap = createRequestMap(call)
                fortRequest.isShowResponsePage = true

                service?.processingTransaction(
                    envType,
                    fortRequest,
                    object : PayFortService.PayFortResultHandler {
                        override fun onResult(fortResult: MutableMap<String, Any?>) {
                            result.success(fortResult)
                        }
                    }
                )
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun createRequestMap(call: MethodCall): MutableMap<String, Any?> {
        val requestMap: MutableMap<String, Any?> = HashMap()
        requestMap["command"] = call.argument<String>("command")
        requestMap["customer_email"] = call.argument<String>("customer_email")
        requestMap["currency"] = call.argument<String>("currency")
        requestMap["amount"] = call.argument<String>("amount")
        requestMap["language"] = call.argument<String>("language")
        requestMap["merchant_reference"] = call.argument<String>("merchant_reference")
        requestMap["order_description"] = call.argument<String>("order_description")
        requestMap["sdk_token"] = call.argument<String>("sdk_token")
        return requestMap
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
    }
}