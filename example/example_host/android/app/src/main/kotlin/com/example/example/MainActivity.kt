package com.example.example
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    companion object {
        const val CHANNEL_MICRO_APP = "flutter/micro_app/app/events"
        const val CHANNEL_ROUTER_COMMAND = "flutter/micro_app/router/command_events"
        const val CHANNEL_ROUTER_LOGGER = "flutter/micro_app/router/logger_events"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val routerChannelMessenger =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_ROUTER_COMMAND)

        val appEventChannelMessenger =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_MICRO_APP)

        MethodChannel(flutterEngine.dartExecutor,CHANNEL_MICRO_APP).setMethodCallHandler{
                call,result ->
            when (call.method) {
                "app_event" -> {

                     if (call.hasArgument("name") && call.argument<String>("name") == "event_from_flutter") {
                         // Use Json String for agnostic platform purposes, or HashMap for Kotlin, Dictionary for Swift or java.util.HashMap for Java

                             /*
                             val argumentsAsJsonString = """
                                {
                                 "name": "event_from_native",
                                 "payload": {},
                                 "distinct": true,
                                 "channels": [],
                                 "version": "1.0.0",
                                 "datetime": "2020-01-01T00:00:00.000Z"
                                }
                             """.trimIndent()

                             appEventChannelMessenger.invokeMethod("app_event", argumentsAsJsonString)
                            */


                         
                         val payload: MutableMap<String, Any> = HashMap()
                         payload["platform"] = "Android"

                         val arguments: MutableMap<String, Any> = HashMap()
                         arguments["name"] = "event_from_native"
                         arguments["payload"] = payload
                         arguments["distinct"] = true
                         arguments["channels"] = emptyList<String>()
                         arguments["version"] = "1.0.0"
                         arguments["datetime"] = "2020-01-01T00:00:00.000Z"

                         // Send event in other thread to flutter side
                         appEventChannelMessenger.invokeMethod("app_event", arguments)

                         // Also, respond in the same thread to flutter side
                         result.success(true)
                     }

                    println("*** Native Android receive (channel: flutter/micro_app/app/events): 'app_event' with arguments: ${call.arguments.toString()} !!")
                } else -> {
                    println("*** Native Android receive (channel: flutter/micro_app/app/events): ${call.method} with arguments: ${call.arguments.toString()} !!")
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor,
            CHANNEL_ROUTER_COMMAND
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "navigation_command" -> {
                    // Please, implement a smart/elegant code to deal with that :)
                    val isNativeRouteOnly = call.arguments.toString().contains("\"route\":\"only_native_page\"")
                    val shouldOpenEmailValidator = call.arguments.toString().contains("\"route\":\"emailValidator\"")

                    if (shouldOpenEmailValidator) {
                        println("*** [navigation_command] page requested by Flutter: ${call.method} (emailValidator)")
                        // Open a Sreen and later return the result to flutter side
                        result.success(true)
                    } else if (isNativeRouteOnly) {
                        println("*** [navigation_command] page requested by Flutter: ${call.method} -> \"only_native_page\" with arguments ${call.arguments}. Should open some Activity(not implemented) on Android side")
                    } else {
                        // Should check if match a route in native side, if not, gives it back to Flutter to open the page Page2
                        println("*** [navigation_command] receive (channel: flutter/micro_app/router/command_events) with arguments: ${call.arguments.toString()} !!")
                        routerChannelMessenger.invokeMethod("navigation_command", "{\"route\":\"example_external/page2\",\"arguments\":\"my arguments\",\"type\":\"pushNative\"}")
                    }
                }
                else -> {
                    println("*** Native Android receive (channel: flutter/micro_app/router/command_events): ${call.method} with arguments: ${call.arguments.toString()} !!")
                }
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor,
            CHANNEL_ROUTER_LOGGER
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "navigation_log" -> {
                    println("*** [navigation_log] received (channel: flutter/micro_app/router/logger_events): 'navigation_event' with arguments: ${call.arguments.toString()} !!")
                } else -> {
                    println("*** [navigation_log] received (channel: flutter/micro_app/router/logger_events): ${call.method} with arguments: ${call.arguments.toString()} !!")
                }
            }
        }
    }
}
