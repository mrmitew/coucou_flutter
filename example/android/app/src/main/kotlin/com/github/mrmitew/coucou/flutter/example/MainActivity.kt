package com.github.mrmitew.coucou.flutter.example

import android.os.Bundle
import com.github.mrmitew.coucou.flutter.CoucouFlutterPlugin
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private lateinit var coucouPlugin: CoucouFlutterPlugin

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        coucouPlugin = CoucouFlutterPlugin(this, flutterView)
    }

    override fun onDestroy() {
        super.onDestroy()
        coucouPlugin.dispose()
    }
}
