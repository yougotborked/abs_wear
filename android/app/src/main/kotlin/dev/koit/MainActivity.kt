package dev.koit.abs_wear

import android.os.Bundle
import android.view.Gravity
import android.view.MotionEvent
import android.widget.Toast
import androidx.annotation.NonNull
import com.samsung.wearable_rotary.WearableRotaryPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    companion object {
        private const val TOAST_CHANNEL = "dev.koit.abs_wear/toast"
    }

    /**
     * A method to hook rotary input events into the "WearableRotaryPlugin" class.
     */
    override fun onGenericMotionEvent(event: MotionEvent?): Boolean {
        return when {
            WearableRotaryPlugin.onGenericMotionEvent(event) -> true
            else -> super.onGenericMotionEvent(event)
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TOAST_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "showToast") {
                    val message = call.argument<String>("message") ?: ""
                    val duration = when (call.argument<String>("length")) {
                        "long" -> Toast.LENGTH_LONG
                        else -> Toast.LENGTH_SHORT
                    }
                    val gravity = when (call.argument<String>("gravity")) {
                        "center" -> Gravity.CENTER
                        "top" -> Gravity.TOP
                        else -> Gravity.BOTTOM
                    }

                    Toast.makeText(applicationContext, message, duration).apply {
                        setGravity(gravity, 0, 0)
                        show()
                    }
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    /**
     * Makes the app assume the rounded canvas appearance on rounded screens.
     */
    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", "transparent")
        super.onCreate(savedInstanceState)
    }
}
