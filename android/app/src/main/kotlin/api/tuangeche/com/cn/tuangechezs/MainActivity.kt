package api.tuangeche.com.cn.tuangechezs

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.tendcloud.tenddata.TCAgent;
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        TCAgent.init(getApplicationContext(), "E96ADEE691E84ACB80622EA8D85B4B02", "firim123456");
    }
}
