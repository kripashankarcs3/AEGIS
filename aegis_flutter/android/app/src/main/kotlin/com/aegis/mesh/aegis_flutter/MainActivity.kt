package com.aegis.mesh.aegis_flutter

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.Context
import android.content.pm.PackageManager
import android.net.wifi.WifiManager
import android.os.Build
import android.os.ParcelUuid
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.UUID

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null
    private var bleAdvertiser: BluetoothLeAdvertiser? = null
    private var advertiseCallback: AdvertiseCallback? = null
    private val CHANNEL = "aegis_ble"
    private val AEGIS_SERVICE_UUID = "a6e5f100-0000-1000-8000-00805f9b34fb"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startAdvertising" -> {
                    val sigId = call.argument<String>("sigId") ?: "SIG-????"
                    val success = startBleAdvertising(sigId)
                    result.success(success)
                }
                "stopAdvertising" -> {
                    stopBleAdvertising()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onStart() {
        super.onStart()
        acquireMulticastLock()
    }

    override fun onStop() {
        super.onStop()
        releaseMulticastLock()
        stopBleAdvertising()
    }

    private fun startBleAdvertising(sigId: String = "SIG-????"): Boolean {
        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
                Log.w("AEGIS", "BLE advertising requires API 21+")
                return false
            }

            if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.BLUETOOTH_ADVERTISE)
                != PackageManager.PERMISSION_GRANTED) {
                Log.w("AEGIS", "BLUETOOTH_ADVERTISE permission not granted")
                return false
            }

            val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            val bluetoothAdapter = bluetoothManager.adapter
            if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled) {
                Log.w("AEGIS", "Bluetooth not enabled")
                return false
            }

            bleAdvertiser = bluetoothAdapter.bluetoothLeAdvertiser
            if (bleAdvertiser == null) {
                Log.w("AEGIS", "BluetoothLeAdvertiser not available")
                return false
            }

            val settings = AdvertiseSettings.Builder()
                .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER)
                .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM)
                .setConnectable(true)
                .build()

            // Advertisement packet (31 bytes): service UUID only for filtering.
            // Must stay under 31 bytes — adding service data here would overflow
            // and cause the data to be silently dropped.
            val advertiseData = AdvertiseData.Builder()
                .setIncludeDeviceName(false)
                .addServiceUuid(ParcelUuid(UUID.fromString(AEGIS_SERVICE_UUID)))
                .build()

            // Scan response (31 bytes): SIG-ID as service data + device name.
            // The scanner requests this after seeing our service UUID.
            val scanData = AdvertiseData.Builder()
                .setIncludeDeviceName(true)
                .addServiceData(
                    ParcelUuid(UUID.fromString(AEGIS_SERVICE_UUID)),
                    sigId.toByteArray(Charsets.UTF_8)
                )
                .build()

            advertiseCallback = object : AdvertiseCallback() {
                override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
                    Log.d("AEGIS", "BLE advertising started successfully")
                }

                override fun onStartFailure(errorCode: Int) {
                    Log.e("AEGIS", "BLE advertising failed: errorCode=$errorCode")
                }
            }

            bleAdvertiser!!.startAdvertising(settings, advertiseData, scanData, advertiseCallback)
            Log.d("AEGIS", "BLE advertising started")
            return true
        } catch (e: Exception) {
            Log.e("AEGIS", "BLE advertising error: ${e.message}")
            return false
        }
    }

    private fun stopBleAdvertising() {
        try {
            if (bleAdvertiser != null && advertiseCallback != null) {
                bleAdvertiser!!.stopAdvertising(advertiseCallback!!)
                Log.d("AEGIS", "BLE advertising stopped")
            }
        } catch (e: Exception) {
            Log.e("AEGIS", "BLE stop error: ${e.message}")
        }
        bleAdvertiser = null
        advertiseCallback = null
    }

    private fun acquireMulticastLock() {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        multicastLock = wifiManager.createMulticastLock("aegis_mdns_lock")
        multicastLock?.setReferenceCounted(true)
        multicastLock?.acquire()
        Log.d("AEGIS", "Multicast lock acquired")
    }

    private fun releaseMulticastLock() {
        if (multicastLock?.isHeld == true) {
            multicastLock?.release()
            Log.d("AEGIS", "Multicast lock released")
        }
    }
}