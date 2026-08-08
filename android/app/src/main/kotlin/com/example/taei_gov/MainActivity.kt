package com.example.taei_gov

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "abha_face_auth"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "launchSandboxApp") {

                val packageName = call.argument<String>("packageName")
                val url = call.argument<String>("url")

                if (packageName == null || url == null) {
                    result.error("INVALID_ARGUMENT", "Missing packageName or url", null)
                    return@setMethodCallHandler
                }

                try {

                    val intent = Intent(Intent.ACTION_VIEW).apply {
                        data = Uri.parse(url)
                        setPackage(packageName)
                        addCategory(Intent.CATEGORY_BROWSABLE)
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }

                    startActivity(intent)

                    result.success(true)

                } catch (e: Exception) {
                    result.error("LAUNCH_ERROR", e.message, null)
                }

            } else {
                result.notImplemented()
            }
        }
    }
}