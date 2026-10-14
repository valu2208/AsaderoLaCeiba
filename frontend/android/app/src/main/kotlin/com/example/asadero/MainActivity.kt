package com.example.asadero

import android.media.MediaScannerConnection
import android.os.Environment
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Las fotos arrastradas al emulador llegan a Descargas pero quedan "pendientes"
        // (invisibles para las apps) hasta que Android las escanea; esto fuerza ese escaneo.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "asadero/media")
            .setMethodCallHandler { call, result ->
                if (call.method == "escanearDescargas") {
                    val descargas = Environment
                        .getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).path
                    MediaScannerConnection.scanFile(this, arrayOf(descargas), null) { _, _ ->
                        Handler(Looper.getMainLooper()).post { result.success(null) }
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}