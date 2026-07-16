package com.aegis.mesh.aegis_flutter

import android.content.Context
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private var multicastLock: WifiManager.MulticastLock? = null

    override fun onStart() {
        super.onStart()
        acquireMulticastLock()
    }

    override fun onStop() {
        super.onStop()
        releaseMulticastLock()
    }

    private fun acquireMulticastLock() {
        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        multicastLock = wifiManager.createMulticastLock("aegis_mdns_lock")
        multicastLock?.setReferenceCounted(true)
        multicastLock?.acquire()
        android.util.Log.d("AEGIS", "Multicast lock acquired")
    }

    private fun releaseMulticastLock() {
        if (multicastLock?.isHeld == true) {
            multicastLock?.release()
            android.util.Log.d("AEGIS", "Multicast lock released")
        }
    }
}
