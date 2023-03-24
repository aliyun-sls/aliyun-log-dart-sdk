package com.aliyun.sls.dart;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import androidx.annotation.NonNull;
import com.aliyun.sls.android.producer.Log;
import com.aliyun.sls.android.producer.LogProducerClient;
import com.aliyun.sls.android.producer.LogProducerConfig;
import com.aliyun.sls.android.producer.LogProducerResult;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AliyunLogFlutterSdkPlugin
 */
public class AliyunLogDartSdkPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private LogProducerConfig logProducerConfig;
    private LogProducerClient logProducerClient;
    private Context context;
    private static final Handler sHandler = new Handler(Looper.getMainLooper());

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "aliyun_sls/flutter_sdk");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "initProducer":
                initProducer(call, result);
                return;
            case "setEndpoint":
            case "setProject":
            case "setLogstore":
            case "setAccessKey":
            case "setSource":
            case "setTopic":
            case "addTag":
            case "updateConfiguration":
                updateConfiguration(call, result);
                return;
            case "addLog":
                addLog(call, result);
                return;
            case "destroy":
                destroy(call, result);
                return;
            default:
                result.notImplemented();
        }
    }

    private void updateConfiguration(MethodCall call, Result result) {
        if (null == logProducerConfig) {
            result.success(error(LogProducerResult.LOG_PRODUCER_INVALID, "LogProducerConfig is null"));
            return;
        }

        updateLogProducerConfig(call);
        result.success(success());
    }

    private void initProducer(MethodCall call, Result result) {
        try {
            logProducerConfig = new LogProducerConfig();
            updateLogProducerConfig(call);
            String error = initPersistent(call);
            if (!TextUtils.isEmpty(error)) {
                result.success((error(LogProducerResult.LOG_PRODUCER_INVALID, error)));
                return;
            }

            logProducerClient = new LogProducerClient(logProducerConfig, (i, s, s1, i1, i2) -> {
                sHandler.post(() -> channel.invokeMethod("on_send_done", new HashMap<String, Object>() {
                        {
                            put("code", i);
                            put("errorMessage", s1);
                            put("logBytes", i2);
                            put("compressedBytes", i2);
                        }
                    }
                ));
            });
            result.success(success());
        } catch (Throwable e) {
            result.success(error(LogProducerResult.LOG_PRODUCER_INVALID, e.getMessage()));
        }
    }

    private void updateLogProducerConfig(MethodCall call) {
        if (null == logProducerConfig) {
            return;
        }

        final String endpoint = optArgument(call, "endpoint", null);
        final String project = optArgument(call, "project", null);
        final String logstore = optArgument(call, "logstore", null);
        final String accessKeyId = optArgument(call, "accessKeyId", null);
        final String accessKeySecret = optArgument(call, "accessKeySecret", null);
        final String securityToken = optArgument(call, "securityToken", null);

        final Boolean debuggable = optArgument(call, "debuggable", null);
        final Integer connectTimeout = optArgument(call, "connectTimeout", null);
        final Integer sendTimeout = optArgument(call, "sendTimeout", null);
        final Integer ntpTimeOffset = optArgument(call, "ntpTimeOffset", null);
        final Integer maxLogDelayTime = optArgument(call, "maxLogDelayTime", null);
        final Boolean dropDelayLog = optArgument(call, "dropDelayLog", null);
        final Boolean dropUnauthorizedLog = optArgument(call, "dropUnauthorizedLog", null);

        final String source = optArgument(call, "source", null);
        final String topic = optArgument(call, "topic", null);
        final Map<String, String> tags = optArgument(call, "tags", null);

        final Integer packetLogBytes = optArgument(call, "packetLogBytes", null);
        final Integer packetLogCount = optArgument(call, "packetLogCount", null);
        final Integer packetTimeout = optArgument(call, "packetTimeout", null);
        final Integer maxBufferLimit = optArgument(call, "maxBufferLimit", null);

        // endpoint & ak
        if (null != endpoint) {
            logProducerConfig.setEndpoint(endpoint);
        }
        if (null != project) {
            logProducerConfig.setProject(project);
        }
        if (null != logstore) {
            logProducerConfig.setLogstore(logstore);
        }
        if (null != accessKeyId && null != accessKeySecret) {
            if (null != securityToken) {
                logProducerConfig.resetSecurityToken(accessKeyId, accessKeySecret, securityToken);
            } else {
                logProducerConfig.setAccessKeyId(accessKeyId);
                logProducerConfig.setAccessKeySecret(accessKeySecret);
            }
        }
        // basic options
        if (null != connectTimeout) {
            logProducerConfig.setConnectTimeoutSec(connectTimeout);
        }
        if (null != sendTimeout) {
            logProducerConfig.setSendTimeoutSec(sendTimeout);
        }
        if (null != ntpTimeOffset) {
            logProducerConfig.setNtpTimeOffset(ntpTimeOffset);
        }
        if (null != maxLogDelayTime) {
            logProducerConfig.setMaxLogDelayTime(maxLogDelayTime);
        }
        if (null != dropDelayLog) {
            logProducerConfig.setDropDelayLog(dropDelayLog ? 1 : 0);
        }
        if (null != dropUnauthorizedLog) {
            logProducerConfig.setDropUnauthorizedLog(dropUnauthorizedLog ? 1 : 0);
        }

        // source & topic & tags
        if (null != source) {
            logProducerConfig.setSource(source);
        }
        if (null != topic) {
            logProducerConfig.setTopic(topic);
        }
        if (null != tags) {
            for (Entry<String, String> entry : tags.entrySet()) {
                logProducerConfig.addTag(entry.getKey(), entry.getValue());
            }
        }

        // packet
        if (null != packetLogBytes) {
            logProducerConfig.setPacketLogBytes(packetLogBytes);
        }
        if (null != packetLogCount) {
            logProducerConfig.setPacketLogCount(packetLogCount);
        }
        if (null != packetTimeout) {
            logProducerConfig.setPacketTimeout(packetTimeout);
        }
        if (null != maxBufferLimit) {
            logProducerConfig.setMaxBufferLimit(maxBufferLimit);
        }

        // debuggable
        if (null != debuggable && debuggable) {
            logProducerConfig.logProducerDebug();
        }
    }

    private String initPersistent(MethodCall call) {
        final Boolean persistent = optArgument(call, "persistent", null);
        final Boolean persistentForceFlush = optArgument(call, "persistentForceFlush", null);
        final String persistentFilePath = optArgument(call, "persistentFilePath", null);
        final Integer persistentMaxFileCount = optArgument(call, "persistentMaxFileCount", null);
        final Integer persistentMaxFileSize = optArgument(call, "persistentMaxFileSize", null);
        final Integer persistentMaxLogCount = optArgument(call, "persistentMaxLogCount", null);

        if (null != persistent && persistent) {
            logProducerConfig.setPersistent(1);
            logProducerConfig.setPersistentForceFlush(null != persistentForceFlush && persistentForceFlush ? 1 : 0);

            logProducerConfig.setPersistentMaxFileCount(null != persistentMaxFileCount ? persistentMaxFileCount : 10);
            logProducerConfig.setPersistentMaxLogCount(
                null != persistentMaxLogCount ? persistentMaxLogCount : 64 * 1024);
            logProducerConfig.setPersistentMaxFileSize(
                null != persistentMaxFileSize ? persistentMaxFileSize : 1024 * 1024);

            if (TextUtils.isEmpty(persistentFilePath)) {
                return "persistent file path must not be null.";
            }

            String path = setupPersistentFilePath(persistentFilePath);
            if (null != path) {
                logProducerConfig.setPersistentFilePath(path);
            }
        }
        return null;
    }

    private String setupPersistentFilePath(String filePath) {
        if (null == context) {
            return null;
        }

        File path = new File(context.getFilesDir(), filePath);
        if (!path.exists()) {
            //noinspection ResultOfMethodCallIgnored
            path.mkdirs();
        }
        return new File(path, "dat").getAbsolutePath();
    }

    private void destroy(MethodCall call, Result result) {
        if (null == logProducerClient) {
            result.success(error(LogProducerResult.LOG_PRODUCER_INVALID, "LogProducerClient is null"));
            return;
        }

        logProducerClient.destroyLogProducer();
        logProducerClient = null;

        result.success(success());
    }

    private void addLog(MethodCall call, Result result) {
        if (null == logProducerClient) {
            result.success(error(LogProducerResult.LOG_PRODUCER_INVALID, "LogProducerClient is null"));
            return;
        }

        Map<String, Object> data = optArgument(call, "log", null);
        if (null == data) {
            result.success(error(LogProducerResult.LOG_PRODUCER_INVALID, "log is null"));
            return;
        }

        Log log = new Log();
        for (Entry<String, Object> entry : data.entrySet()) {
            log.putContent(entry.getKey(), String.valueOf(entry.getValue()));
        }

        LogProducerResult res = logProducerClient.addLog(log);
        if (res == LogProducerResult.LOG_PRODUCER_OK) {
            result.success(success());
        } else {
            result.success(error(res));
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        if (null != logProducerClient) {
            logProducerClient.destroyLogProducer();
        }
    }

    private static <T> T optArgument(MethodCall call, String key, T def) {
        try {
            //noinspection unchecked
            return (T)call.argument(key);
        } catch (Throwable t) {
            return def;
        }
    }

    private static Map<String, Object> success() {
        return success(null);
    }

    private static Map<String, Object> success(Map<String, Object> data) {
        return createResultData(LogProducerResult.LOG_PRODUCER_OK, data, null);
    }

    private static Map<String, Object> error(LogProducerResult code) {
        return error(code, null);
    }

    private static Map<String, Object> error(LogProducerResult code, String error) {
        return createResultData(code, null, error);
    }

    private static Map<String, Object> createResultData(LogProducerResult code, Map<String, Object> data,
        String error) {
        return new HashMap<String, Object>() {
            {
                put("code", code.ordinal());
                put("data", null != data ? data : new HashMap<>());
                put("error", TextUtils.isEmpty(error) ? "" : error);
            }
        };
    }
}
