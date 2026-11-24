#!/bin/bash
set -e

mkdir -p app/src/main/res/drawable app/src/main/res/values app/src/main/res/layout app/src/main/res/xml app/src/main/java/com/sales/bill

cat << 'EOF' > settings.gradle
pluginManagement {
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories { google(); mavenCentral() }
}
rootProject.name = "SalesBillApp"
include ':app'
EOF

cat << 'EOF' > build.gradle
plugins {
    id 'com.android.application' version '8.9.1' apply false
}
EOF

cat << 'EOF' > gradle.properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=false
EOF

cat << 'EOF' > app/build.gradle
plugins {
    id 'com.android.application'
}
android {
    namespace 'com.sales.bill'
    compileSdk 35
    defaultConfig {
        applicationId "com.sales.bill"
        minSdk 24
        targetSdk 35
        versionCode 1
        versionName "1.5"
    }
    buildTypes {
        release { minifyEnabled false }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
dependencies {
    implementation 'androidx.appcompat:appcompat:1.7.0'
    implementation 'com.google.android.material:material:1.12.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.2.0'
    implementation 'androidx.recyclerview:recyclerview:1.3.2'
    implementation 'com.unity3d.ads:unity-ads:4.18.1'
}
EOF

cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <application
        android:allowBackup="true"
        android:icon="@drawable/ic_bill_logo"
        android:label="@string/app_name"
        android:roundIcon="@drawable/ic_bill_logo"
        android:supportsRtl="true"
        android:theme="@style/Theme.SalesBill">
        <activity android:name=".MainActivity" android:exported="true" android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        <activity android:name=".SavedBillsActivity" android:exported="false" />
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="com.sales.bill.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data android:name="android.support.FILE_PROVIDER_PATHS" android:resource="@xml/file_paths" />
        </provider>
    </application>
</manifest>
EOF

cat << 'EOF' > app/src/main/res/xml/file_paths.xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <external-files-path name="my_docs" path="." />
    <cache-path name="cache" path="." />
</paths>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_bill_logo.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android" android:width="108dp" android:height="108dp" android:viewportWidth="24" android:viewportHeight="24">
    <path android:fillColor="#1E40AF" android:pathData="M12,2A10,10 0 1,0 22,12A10,10 0 0,0 12,2Z" />
    <path android:fillColor="#FFFFFF" android:pathData="M7,6H17V18L15,16.5L13,18L11,16.5L9,18L7,16.5V6ZM9,9V10.5H15V9H9ZM9,12V13.5H15V12H9Z" />
</vector>
EOF

cat << 'EOF' > app/src/main/res/values/colors.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="primary">#1E40AF</color>
    <color name="primary_dark">#1E3A8A</color>
    <color name="accent">#059669</color>
    <color name="bg_light">#F3F4F6</color>
    <color name="white">#FFFFFF</color>
    <color name="text_dark">#111827</color>
    <color name="text_gray">#6B7280</color>
    <color name="divider">#D1D5DB</color>
    <color name="red">#DC2626</color>
</resources>
EOF

cat << 'EOF' > app/src/main/res/values/strings.xml
<resources>
    <string name="app_name">Sales Bill Voucher</string>
</resources>
EOF

cat << 'EOF' > app/src/main/res/values/themes.xml
<resources>
    <style name="Theme.SalesBill" parent="Theme.MaterialComponents.DayNight.NoActionBar">
        <item name="colorPrimary">@color/primary</item>
        <item name="colorPrimaryVariant">@color/primary_dark</item>
        <item name="colorOnPrimary">@color/white</item>
        <item name="colorSecondary">@color/accent</item>
        <item name="android:statusBarColor">@color/primary_dark</item>
    </style>
</resources>
EOF

cat << 'EOF' > app/src/main/res/layout/activity_main.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android" xmlns:app="http://schemas.android.com/apk/res-auto" android:layout_width="match_parent" android:layout_height="match_parent" android:background="@color/bg_light" android:orientation="vertical">
    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:background="@color/primary" android:gravity="center_vertical" android:orientation="horizontal" android:padding="14dp">
        <LinearLayout android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:orientation="vertical">
            <TextView android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="Sales Bill Voucher" android:textColor="@color/white" android:textSize="19sp" android:textStyle="bold" />
            <TextView android:id="@+id/tvBillMeta" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="Bill No: INV-1001 | Date: --" android:textColor="#DBEAFE" android:textSize="12sp" />
        </LinearLayout>
        <com.google.android.material.button.MaterialButton android:id="@+id/btnSavedBills" style="@style/Widget.MaterialComponents.Button.OutlinedButton" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="Saved Bills" android:textAllCaps="false" android:textColor="@color/white" app:strokeColor="@color/white" />
    </LinearLayout>
    <FrameLayout android:id="@+id/bannerContainer" android:layout_width="match_parent" android:layout_height="wrap_content" android:background="@color/white" android:paddingVertical="2dp" />
    <View android:layout_width="match_parent" android:layout_height="1dp" android:background="@color/divider" />
    <ScrollView android:layout_width="match_parent" android:layout_height="0dp" android:layout_weight="1">
        <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="vertical" android:padding="12dp">
            <com.google.android.material.card.MaterialCardView android:layout_width="match_parent" android:layout_height="wrap_content" app:cardCornerRadius="12dp" app:cardElevation="2dp">
                <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="vertical" android:padding="14dp">
                    <TextView android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="Party Details" android:textColor="@color/primary" android:textSize="15sp" android:textStyle="bold" />
                    <com.google.android.material.textfield.TextInputLayout style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="8dp" android:hint="Party Name *">
                        <com.google.android.material.textfield.TextInputEditText android:id="@+id/etPartyName" android:layout_width="match_parent" android:layout_height="wrap_content" android:inputType="textPersonName" />
                    </com.google.android.material.textfield.TextInputLayout>
                    <com.google.android.material.textfield.TextInputLayout style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="8dp" android:hint="Address">
                        <com.google.android.material.textfield.TextInputEditText android:id="@+id/etAddress" android:layout_width="match_parent" android:layout_height="wrap_content" android:inputType="textPostalAddress" />
                    </com.google.android.material.textfield.TextInputLayout>
                    <com.google.android.material.textfield.TextInputLayout style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="8dp" android:hint="Mobile Number">
                        <com.google.android.material.textfield.TextInputEditText android:id="@+id/etMobile" android:layout_width="match_parent" android:layout_height="wrap_content" android:inputType="phone" android:maxLength="15" />
                    </com.google.android.material.textfield.TextInputLayout>
                </LinearLayout>
            </com.google.android.material.card.MaterialCardView>
            <View android:layout_width="match_parent" android:layout_height="2dp" android:layout_marginVertical="14dp" android:background="@color/primary" />
            <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginBottom="8dp" android:gravity="center_vertical" android:orientation="horizontal">
                <TextView android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:text="Items List" android:textColor="@color/text_dark" android:textSize="16sp" android:textStyle="bold" />
                <com.google.android.material.button.MaterialButton android:id="@+id/btnAddItem" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="+ Add Item" android:textAllCaps="false" app:cornerRadius="8dp" />
            </LinearLayout>
            <LinearLayout android:id="@+id/llItemsContainer" android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="vertical" />
            <com.google.android.material.card.MaterialCardView android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="8dp" app:cardCornerRadius="12dp" app:cardElevation="2dp">
                <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="vertical" android:padding="14dp">
                    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="horizontal">
                        <TextView android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:text="Sub Total:" android:textColor="@color/text_dark" android:textSize="15sp" />
                        <TextView android:id="@+id/tvSubTotal" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="₹0.00" android:textColor="@color/text_dark" android:textSize="15sp" android:textStyle="bold" />
                    </LinearLayout>
                    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="10dp" android:gravity="center_vertical" android:orientation="horizontal">
                        <TextView android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="GST Rate (%):" android:textColor="@color/text_dark" android:textSize="14sp" />
                        <EditText android:id="@+id/etGstRate" android:layout_width="70dp" android:layout_height="wrap_content" android:layout_marginStart="8dp" android:background="@android:drawable/edit_text" android:gravity="center" android:inputType="numberDecimal" android:padding="6dp" android:text="18" android:textSize="14sp" />
                        <TextView android:id="@+id/tvGstAmount" android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:gravity="end" android:text="₹0.00" android:textColor="@color/text_gray" android:textSize="14sp" android:textStyle="bold" />
                    </LinearLayout>
                    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="8dp" android:orientation="horizontal">
                        <Button android:id="@+id/btnGst0" style="?android:attr/buttonBarButtonStyle" android:layout_width="0dp" android:layout_height="36dp" android:layout_weight="1" android:text="0%" android:textSize="12sp" />
                        <Button android:id="@+id/btnGst5" style="?android:attr/buttonBarButtonStyle" android:layout_width="0dp" android:layout_height="36dp" android:layout_weight="1" android:text="5%" android:textSize="12sp" />
                        <Button android:id="@+id/btnGst12" style="?android:attr/buttonBarButtonStyle" android:layout_width="0dp" android:layout_height="36dp" android:layout_weight="1" android:text="12%" android:textSize="12sp" />
                        <Button android:id="@+id/btnGst18" style="?android:attr/buttonBarButtonStyle" android:layout_width="0dp" android:layout_height="36dp" android:layout_weight="1" android:text="18%" android:textSize="12sp" />
                        <Button android:id="@+id/btnGst28" style="?android:attr/buttonBarButtonStyle" android:layout_width="0dp" android:layout_height="36dp" android:layout_weight="1" android:text="28%" android:textSize="12sp" />
                    </LinearLayout>
                    <View android:layout_width="match_parent" android:layout_height="1dp" android:layout_marginVertical="10dp" android:background="@color/divider" />
                    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="horizontal">
                        <TextView android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:text="Grand Total:" android:textColor="@color/primary" android:textSize="18sp" android:textStyle="bold" />
                        <TextView android:id="@+id/tvGrandTotal" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="₹0.00" android:textColor="@color/accent" android:textSize="20sp" android:textStyle="bold" />
                    </LinearLayout>
                </LinearLayout>
            </com.google.android.material.card.MaterialCardView>
            <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="14dp" android:orientation="horizontal">
                <com.google.android.material.button.MaterialButton android:id="@+id/btnSaveBill" android:layout_width="0dp" android:layout_height="52dp" android:layout_marginEnd="6dp" android:layout_weight="1" android:backgroundTint="@color/primary" android:text="Save Bill" android:textAllCaps="false" android:textStyle="bold" app:cornerRadius="10dp" />
                <com.google.android.material.button.MaterialButton android:id="@+id/btnDownloadPdf" android:layout_width="0dp" android:layout_height="52dp" android:layout_marginStart="6dp" android:layout_weight="1" android:backgroundTint="@color/accent" android:text="PDF Download" android:textAllCaps="false" android:textStyle="bold" app:cornerRadius="10dp" />
            </LinearLayout>
            <com.google.android.material.button.MaterialButton android:id="@+id/btnNewBill" style="@style/Widget.MaterialComponents.Button.OutlinedButton" android:layout_width="match_parent" android:layout_height="46dp" android:layout_marginTop="8dp" android:text="Clear / New Bill" android:textAllCaps="false" app:cornerRadius="10dp" />
        </LinearLayout>
    </ScrollView>
</LinearLayout>
EOF

cat << 'EOF' > app/src/main/res/layout/item_bill_row.xml
<?xml version="1.0" encoding="utf-8"?>
<com.google.android.material.card.MaterialCardView xmlns:android="http://schemas.android.com/apk/res/android" xmlns:app="http://schemas.android.com/apk/res-auto" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginBottom="10dp" app:cardCornerRadius="10dp" app:cardElevation="2dp">
    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="vertical" android:padding="12dp">
        <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:gravity="center_vertical" android:orientation="horizontal">
            <TextView android:id="@+id/tvItemNumber" android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:text="Item #1" android:textColor="@color/primary" android:textSize="13sp" android:textStyle="bold" />
            <TextView android:id="@+id/btnRemoveItem" android:layout_width="wrap_content" android:layout_height="wrap_content" android:paddingHorizontal="8dp" android:paddingVertical="2dp" android:text="✕ Remove" android:textColor="@color/red" android:textSize="12sp" android:textStyle="bold" />
        </LinearLayout>
        <EditText android:id="@+id/etItemName" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="4dp" android:hint="Item Name (e.g. Rice Bag)" android:inputType="textCapWords" android:textSize="14sp" />
        <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="6dp" android:gravity="center_vertical" android:orientation="horizontal">
            <EditText android:id="@+id/etQty" android:layout_width="0dp" android:layout_height="wrap_content" android:layout_marginEnd="6dp" android:layout_weight="1" android:hint="Qty" android:inputType="numberDecimal" android:textSize="14sp" />
            <EditText android:id="@+id/etRate" android:layout_width="0dp" android:layout_height="wrap_content" android:layout_marginEnd="6dp" android:layout_weight="1" android:hint="Rate (₹)" android:inputType="numberDecimal" android:textSize="14sp" />
            <LinearLayout android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1.1" android:gravity="end" android:orientation="vertical">
                <TextView android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="Amount" android:textColor="@color/text_gray" android:textSize="11sp" />
                <TextView android:id="@+id/tvRowAmount" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="₹0.00" android:textColor="@color/text_dark" android:textSize="15sp" android:textStyle="bold" />
            </LinearLayout>
        </LinearLayout>
    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
EOF

cat << 'EOF' > app/src/main/res/layout/activity_saved_bills.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android" android:layout_width="match_parent" android:layout_height="match_parent" android:background="@color/bg_light" android:orientation="vertical">
    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:background="@color/primary" android:gravity="center_vertical" android:orientation="horizontal" android:padding="12dp">
        <com.google.android.material.button.MaterialButton android:id="@+id/btnBack" style="@style/Widget.MaterialComponents.Button.TextButton" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="← Back" android:textAllCaps="false" android:textColor="@color/white" />
        <TextView android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_marginStart="8dp" android:text="Saved Bills" android:textColor="@color/white" android:textSize="19sp" android:textStyle="bold" />
    </LinearLayout>
    <FrameLayout android:id="@+id/bannerContainer" android:layout_width="match_parent" android:layout_height="wrap_content" android:background="@color/white" android:paddingVertical="2dp" />
    <TextView android:id="@+id/tvEmpty" android:layout_width="match_parent" android:layout_height="wrap_content" android:gravity="center" android:padding="32dp" android:text="Abhi koi bill save nahi kiya gaya hai." android:textColor="@color/text_gray" android:textSize="15sp" android:visibility="gone" />
    <androidx.recyclerview.widget.RecyclerView android:id="@+id/rvSavedBills" android:layout_width="match_parent" android:layout_height="0dp" android:layout_weight="1" android:padding="12dp" />
</LinearLayout>
EOF

cat << 'EOF' > app/src/main/res/layout/item_saved_bill.xml
<?xml version="1.0" encoding="utf-8"?>
<com.google.android.material.card.MaterialCardView xmlns:android="http://schemas.android.com/apk/res/android" xmlns:app="http://schemas.android.com/apk/res-auto" android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginBottom="10dp" app:cardCornerRadius="12dp" app:cardElevation="2dp">
    <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="vertical" android:padding="14dp">
        <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:orientation="horizontal">
            <TextView android:id="@+id/tvSbParty" android:layout_width="0dp" android:layout_height="wrap_content" android:layout_weight="1" android:text="Party Name" android:textColor="@color/text_dark" android:textSize="16sp" android:textStyle="bold" />
            <TextView android:id="@+id/tvSbTotal" android:layout_width="wrap_content" android:layout_height="wrap_content" android:text="₹0.00" android:textColor="@color/accent" android:textSize="16sp" android:textStyle="bold" />
        </LinearLayout>
        <TextView android:id="@+id/tvSbInfo" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_marginTop="4dp" android:text="INV-1001 | Date | Mobile" android:textColor="@color/text_gray" android:textSize="12sp" />
        <LinearLayout android:layout_width="match_parent" android:layout_height="wrap_content" android:layout_marginTop="10dp" android:orientation="horizontal">
            <com.google.android.material.button.MaterialButton android:id="@+id/btnSbPdf" android:layout_width="0dp" android:layout_height="40dp" android:layout_marginEnd="6dp" android:layout_weight="1" android:backgroundTint="@color/accent" android:text="PDF / Share" android:textAllCaps="false" android:textSize="13sp" />
            <com.google.android.material.button.MaterialButton android:id="@+id/btnSbDelete" style="@style/Widget.MaterialComponents.Button.OutlinedButton" android:layout_width="wrap_content" android:layout_height="40dp" android:text="Delete" android:textAllCaps="false" android:textColor="@color/red" android:textSize="13sp" app:strokeColor="@color/red" />
        </LinearLayout>
    </LinearLayout>
</com.google.android.material.card.MaterialCardView>
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/AdsHelper.java
package com.sales.bill;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.unity3d.ads.IUnityAdsInitializationListener;
import com.unity3d.ads.IUnityAdsLoadListener;
import com.unity3d.ads.IUnityAdsShowListener;
import com.unity3d.ads.UnityAds;
import com.unity3d.ads.UnityAdsShowOptions;
import com.unity3d.services.banners.BannerErrorInfo;
import com.unity3d.services.banners.BannerView;
import com.unity3d.services.banners.UnityBannerSize;

import java.util.ArrayList;
import java.util.List;

public class AdsHelper {

    public static final String UNITY_GAME_ID = "800447446";
    public static final String BANNER_AD_UNIT = "BP_Banner_Android";
    public static final String INTERSTITIAL_AD_UNIT = "BP_Interstitial_Android";
    public static final boolean TEST_MODE = false;

    private static boolean initializing = false;
    private static boolean interstitialLoaded = false;
    private static final List<Runnable> pendingTasks = new ArrayList<>();

    public static void initAndRun(Activity activity, Runnable onReady) {
        if (UnityAds.isInitialized()) {
            if (onReady != null) onReady.run();
            return;
        }
        if (onReady != null) pendingTasks.add(onReady);
        if (initializing) return;
        initializing = true;

        UnityAds.initialize(activity.getApplicationContext(), UNITY_GAME_ID, TEST_MODE, new IUnityAdsInitializationListener() {
            @Override
            public void onInitializationComplete() {
                initializing = false;
                loadInterstitial();
                List<Runnable> copy = new ArrayList<>(pendingTasks);
                pendingTasks.clear();
                new Handler(Looper.getMainLooper()).post(() -> {
                    for (Runnable r : copy) r.run();
                });
            }
            @Override
            public void onInitializationFailed(UnityAds.UnityAdsInitializationError error, String message) {
                initializing = false;
                pendingTasks.clear();
            }
        });
    }

    public static void loadInterstitial() {
        if (!UnityAds.isInitialized()) return;
        UnityAds.load(INTERSTITIAL_AD_UNIT, new IUnityAdsLoadListener() {
            @Override public void onUnityAdsAdLoaded(String placementId) { interstitialLoaded = true; }
            @Override public void onUnityAdsFailedToLoad(String placementId, UnityAds.UnityAdsLoadError error, String message) {
                interstitialLoaded = false;
                new Handler(Looper.getMainLooper()).postDelayed(() -> {
                    if (UnityAds.isInitialized() && !interstitialLoaded) {
                        UnityAds.load(INTERSTITIAL_AD_UNIT, new IUnityAdsLoadListener() {
                            @Override public void onUnityAdsAdLoaded(String p) { interstitialLoaded = true; }
                            @Override public void onUnityAdsFailedToLoad(String p, UnityAds.UnityAdsLoadError e, String m) { interstitialLoaded = false; }
                        });
                    }
                }, 8000);
            }
        });
    }

    public static void showInterstitialThen(Activity activity, Runnable afterAd) {
        if (!interstitialLoaded || !UnityAds.isInitialized()) {
            initAndRun(activity, AdsHelper::loadInterstitial);
            if (afterAd != null) afterAd.run();
            return;
        }
        interstitialLoaded = false;
        UnityAds.show(activity, INTERSTITIAL_AD_UNIT, new UnityAdsShowOptions(), new IUnityAdsShowListener() {
            @Override public void onUnityAdsShowFailure(String placementId, UnityAds.UnityAdsShowError error, String message) {
                loadInterstitial();
                activity.runOnUiThread(() -> { if (afterAd != null && !activity.isFinishing() && !activity.isDestroyed()) afterAd.run(); });
            }
            @Override public void onUnityAdsShowStart(String placementId) {}
            @Override public void onUnityAdsShowClick(String placementId) {}
            @Override public void onUnityAdsShowComplete(String placementId, UnityAds.UnityAdsShowCompletionState state) {
                loadInterstitial();
                activity.runOnUiThread(() -> { if (afterAd != null && !activity.isFinishing() && !activity.isDestroyed()) afterAd.run(); });
            }
        });
    }

    public static BannerView attachBanner(Activity activity, FrameLayout container) {
        if (container == null) return null;
        BannerView bannerView = new BannerView(activity, BANNER_AD_UNIT, new UnityBannerSize(320, 50));
        final int[] retries = {0};
        bannerView.setListener(new BannerView.IListener() {
            @Override public void onBannerLoaded(BannerView bannerAdView) { retries[0] = 0; }
            @Override public void onBannerShown(BannerView bannerAdView) {}
            @Override public void onBannerClick(BannerView bannerAdView) {}
            @Override public void onBannerFailedToLoad(BannerView bannerAdView, BannerErrorInfo errorInfo) {
                if (retries[0] < 3 && !activity.isFinishing() && !activity.isDestroyed()) {
                    retries[0]++;
                    new Handler(Looper.getMainLooper()).postDelayed(() -> {
                        if (!activity.isFinishing() && !activity.isDestroyed()) bannerAdView.load();
                    }, 8000);
                }
            }
            @Override public void onBannerLeftApplication(BannerView bannerAdView) {}
        });
        container.removeAllViews();
        FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER;
        container.addView(bannerView, lp);
        initAndRun(activity, () -> { if (!activity.isFinishing() && !activity.isDestroyed()) bannerView.load(); });
        return bannerView;
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/BillItem.java
package com.sales.bill;

public class BillItem {
    public String name;
    public double qty, rate, amount;
    public BillItem(String name, double qty, double rate) {
        this.name = name; this.qty = qty; this.rate = rate; this.amount = qty * rate;
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/BillModel.java
package com.sales.bill;

import java.util.ArrayList;
import java.util.List;

public class BillModel {
    public long id;
    public String billNo, billDate, partyName, address, mobile;
    public double subTotal, gstRate, gstAmount, grandTotal;
    public List<BillItem> items = new ArrayList<>();
}
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/BillDbHelper.java
package com.sales.bill;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.List;

public class BillDbHelper extends SQLiteOpenHelper {
    private static final String DB_NAME = "sales_bills.db";
    private static final String TABLE = "bills";
    public BillDbHelper(Context context) { super(context, DB_NAME, null, 1); }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE " + TABLE + " (id INTEGER PRIMARY KEY AUTOINCREMENT, billNo TEXT, billDate TEXT, partyName TEXT, address TEXT, mobile TEXT, subTotal REAL, gstRate REAL, gstAmount REAL, grandTotal REAL, itemsJson TEXT)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int o, int n) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE); onCreate(db);
    }

    public String getNextBillNo() {
        Cursor c = getReadableDatabase().rawQuery("SELECT COUNT(*) FROM " + TABLE, null);
        int count = c.moveToFirst() ? c.getInt(0) : 0;
        c.close();
        return "INV-" + (1001 + count);
    }

    public long insertBill(BillModel bill) {
        ContentValues cv = new ContentValues();
        cv.put("billNo", bill.billNo); cv.put("billDate", bill.billDate);
        cv.put("partyName", bill.partyName); cv.put("address", bill.address); cv.put("mobile", bill.mobile);
        cv.put("subTotal", bill.subTotal); cv.put("gstRate", bill.gstRate);
        cv.put("gstAmount", bill.gstAmount); cv.put("grandTotal", bill.grandTotal);
        cv.put("itemsJson", itemsToJson(bill.items));
        return getWritableDatabase().insert(TABLE, null, cv);
    }

    public List<BillModel> getAllBills() {
        List<BillModel> list = new ArrayList<>();
        Cursor c = getReadableDatabase().rawQuery("SELECT * FROM " + TABLE + " ORDER BY id DESC", null);
        if (c.moveToFirst()) {
            do {
                BillModel b = new BillModel();
                b.id = c.getLong(c.getColumnIndexOrThrow("id"));
                b.billNo = c.getString(c.getColumnIndexOrThrow("billNo"));
                b.billDate = c.getString(c.getColumnIndexOrThrow("billDate"));
                b.partyName = c.getString(c.getColumnIndexOrThrow("partyName"));
                b.address = c.getString(c.getColumnIndexOrThrow("address"));
                b.mobile = c.getString(c.getColumnIndexOrThrow("mobile"));
                b.subTotal = c.getDouble(c.getColumnIndexOrThrow("subTotal"));
                b.gstRate = c.getDouble(c.getColumnIndexOrThrow("gstRate"));
                b.gstAmount = c.getDouble(c.getColumnIndexOrThrow("gstAmount"));
                b.grandTotal = c.getDouble(c.getColumnIndexOrThrow("grandTotal"));
                b.items = jsonToItems(c.getString(c.getColumnIndexOrThrow("itemsJson")));
                list.add(b);
            } while (c.moveToNext());
        }
        c.close();
        return list;
    }

    public void deleteBill(long id) {
        getWritableDatabase().delete(TABLE, "id=?", new String[]{String.valueOf(id)});
    }

    private String itemsToJson(List<BillItem> items) {
        JSONArray arr = new JSONArray();
        try {
            for (BillItem item : items) {
                JSONObject obj = new JSONObject();
                obj.put("name", item.name); obj.put("qty", item.qty); obj.put("rate", item.rate); obj.put("amount", item.amount);
                arr.put(obj);
            }
        } catch (Exception ignored) {}
        return arr.toString();
    }

    private List<BillItem> jsonToItems(String json) {
        List<BillItem> list = new ArrayList<>();
        try {
            JSONArray arr = new JSONArray(json);
            for (int i = 0; i < arr.length(); i++) {
                JSONObject o = arr.getJSONObject(i);
                BillItem item = new BillItem(o.optString("name"), o.optDouble("qty"), o.optDouble("rate"));
                item.amount = o.optDouble("amount", item.qty * item.rate);
                list.add(item);
            }
        } catch (Exception ignored) {}
        return list;
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/PdfHelper.java
package com.sales.bill;

import android.app.AlertDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.graphics.pdf.PdfDocument;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.widget.Toast;
import androidx.core.content.FileProvider;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.Locale;

public class PdfHelper {
    public static void createAndShowPdf(Context context, BillModel bill) {
        PdfDocument pdf = new PdfDocument();
        int pageWidth = 595, pageHeight = 842;
        Paint titlePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        titlePaint.setColor(Color.parseColor("#1E40AF")); titlePaint.setTextSize(22f);
        titlePaint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        Paint boldPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        boldPaint.setColor(Color.BLACK); boldPaint.setTextSize(12f);
        boldPaint.setTypeface(Typeface.create(Typeface.DEFAULT, Typeface.BOLD));
        Paint textPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        textPaint.setColor(Color.DKGRAY); textPaint.setTextSize(11.5f);
        Paint rightBold = new Paint(boldPaint); rightBold.setTextAlign(Paint.Align.RIGHT);
        Paint rightText = new Paint(textPaint); rightText.setTextAlign(Paint.Align.RIGHT);
        Paint linePaint = new Paint(); linePaint.setColor(Color.parseColor("#1E40AF")); linePaint.setStrokeWidth(1.5f);
        Paint headerBg = new Paint(); headerBg.setColor(Color.parseColor("#E5E7EB"));

        int pageNum = 1;
        PdfDocument.PageInfo pageInfo = new PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNum).create();
        PdfDocument.Page page = pdf.startPage(pageInfo);
        Canvas canvas = page.getCanvas();

        int y = 50;
        canvas.drawText("SALES BILL / VOUCHER", 40, y, titlePaint);
        canvas.drawText("Bill No: " + bill.billNo, pageWidth - 40, y - 6, rightBold);
        canvas.drawText("Date: " + bill.billDate, pageWidth - 40, y + 10, rightText);
        y += 22; canvas.drawLine(40, y, pageWidth - 40, y, linePaint);
        y += 22; canvas.drawText("Bill To (Party):", 40, y, boldPaint);
        y += 16; canvas.drawText("Name: " + safe(bill.partyName), 40, y, textPaint); y += 15;
        if (!safe(bill.address).isEmpty()) { canvas.drawText("Address: " + safe(bill.address), 40, y, textPaint); y += 15; }
        if (!safe(bill.mobile).isEmpty()) { canvas.drawText("Mobile: " + safe(bill.mobile), 40, y, textPaint); y += 15; }
        y += 6; canvas.drawLine(40, y, pageWidth - 40, y, linePaint); y += 16;

        canvas.drawRect(40, y - 14, pageWidth - 40, y + 8, headerBg);
        canvas.drawText("S.No", 46, y, boldPaint); canvas.drawText("Item Name", 86, y, boldPaint);
        canvas.drawText("Qty", 350, y, rightBold); canvas.drawText("Rate", 440, y, rightBold);
        canvas.drawText("Amount", pageWidth - 46, y, rightBold); y += 24;

        int idx = 1;
        for (BillItem item : bill.items) {
            if (y > 760) {
                pdf.finishPage(page); pageNum++;
                pageInfo = new PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNum).create();
                page = pdf.startPage(pageInfo); canvas = page.getCanvas(); y = 50;
            }
            String name = item.name.length() > 32 ? item.name.substring(0, 32) + "..." : item.name;
            canvas.drawText(String.valueOf(idx++), 46, y, textPaint);
            canvas.drawText(name, 86, y, textPaint);
            canvas.drawText(fmtQty(item.qty), 350, y, rightText);
            canvas.drawText(String.format(Locale.getDefault(), "%.2f", item.rate), 440, y, rightText);
            canvas.drawText(String.format(Locale.getDefault(), "%.2f", item.amount), pageWidth - 46, y, rightText);
            y += 20;
        }
        if (y > 700) {
            pdf.finishPage(page); pageNum++;
            pageInfo = new PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageNum).create();
            page = pdf.startPage(pageInfo); canvas = page.getCanvas(); y = 50;
        }
        y += 8; canvas.drawLine(40, y, pageWidth - 40, y, linePaint); y += 22;
        canvas.drawText("Sub Total:", 420, y, rightText);
        canvas.drawText(String.format(Locale.getDefault(), "Rs. %.2f", bill.subTotal), pageWidth - 46, y, rightBold); y += 18;
        canvas.drawText(String.format(Locale.getDefault(), "GST (%.1f%%):", bill.gstRate), 420, y, rightText);
        canvas.drawText(String.format(Locale.getDefault(), "Rs. %.2f", bill.gstAmount), pageWidth - 46, y, rightBold); y += 20;

        canvas.drawRect(300, y - 16, pageWidth - 40, y + 10, headerBg);
        Paint grandPaint = new Paint(rightBold); grandPaint.setColor(Color.parseColor("#059669")); grandPaint.setTextSize(14f);
        canvas.drawText("Grand Total:", 420, y, grandPaint);
        canvas.drawText(String.format(Locale.getDefault(), "Rs. %.2f", bill.grandTotal), pageWidth - 46, y, grandPaint);
        y += 50; canvas.drawText("Thank you for your business!", 40, y, textPaint);
        pdf.finishPage(page);

        try {
            String fileName = "Bill_" + bill.billNo.replaceAll("[^a-zA-Z0-9_-]", "_") + ".pdf";
            File dir = context.getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS);
            if (dir != null && !dir.exists()) dir.mkdirs();
            File localFile = new File(dir, fileName);
            FileOutputStream fos = new FileOutputStream(localFile); pdf.writeTo(fos); fos.close(); pdf.close();

            boolean saved = false;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                ContentValues v = new ContentValues();
                v.put(MediaStore.Downloads.DISPLAY_NAME, fileName);
                v.put(MediaStore.Downloads.MIME_TYPE, "application/pdf");
                v.put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS);
                Uri dlUri = context.getContentResolver().insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, v);
                if (dlUri != null) {
                    OutputStream os = context.getContentResolver().openOutputStream(dlUri);
                    if (os != null) {
                        FileInputStream fis = new FileInputStream(localFile);
                        byte[] buf = new byte[4096]; int len;
                        while ((len = fis.read(buf)) > 0) os.write(buf, 0, len);
                        fis.close(); os.close(); saved = true;
                    }
                }
            }
            Uri shareUri = FileProvider.getUriForFile(context, "com.sales.bill.fileprovider", localFile);
            new AlertDialog.Builder(context)
                    .setTitle("Bill PDF Ready!")
                    .setMessage(saved ? "PDF Downloads folder mein save ho gayi hai (" + fileName + ")" : "PDF ban gayi hai (" + fileName + ")")
                    .setPositiveButton("Open PDF", (d, w) -> {
                        Intent i = new Intent(Intent.ACTION_VIEW);
                        i.setDataAndType(shareUri, "application/pdf");
                        i.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                        try { context.startActivity(i); } catch (Exception e) { Toast.makeText(context, "PDF viewer nahi mila, Share karein", Toast.LENGTH_SHORT).show(); }
                    })
                    .setNeutralButton("Share", (d, w) -> {
                        Intent s = new Intent(Intent.ACTION_SEND); s.setType("application/pdf");
                        s.putExtra(Intent.EXTRA_STREAM, shareUri); s.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                        context.startActivity(Intent.createChooser(s, "Share Bill PDF"));
                    })
                    .setNegativeButton("Close", null).show();
        } catch (Exception e) {
            pdf.close(); Toast.makeText(context, "PDF Error: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }
    private static String safe(String s) { return s == null ? "" : s.trim(); }
    private static String fmtQty(double q) { return q == (long) q ? String.valueOf((long) q) : String.format(Locale.getDefault(), "%.2f", q); }
}
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/MainActivity.java
package com.sales.bill;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.textfield.TextInputEditText;
import com.unity3d.services.banners.BannerView;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {
    private TextView tvBillMeta, tvSubTotal, tvGstAmount, tvGrandTotal;
    private TextInputEditText etPartyName, etAddress, etMobile;
    private EditText etGstRate;
    private LinearLayout llItemsContainer;
    private BillDbHelper dbHelper;
    private String currentBillNo, currentDate;
    private BannerView bannerView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        dbHelper = new BillDbHelper(this);
        bannerView = AdsHelper.attachBanner(this, (FrameLayout) findViewById(R.id.bannerContainer));

        tvBillMeta = findViewById(R.id.tvBillMeta); tvSubTotal = findViewById(R.id.tvSubTotal);
        tvGstAmount = findViewById(R.id.tvGstAmount); tvGrandTotal = findViewById(R.id.tvGrandTotal);
        etPartyName = findViewById(R.id.etPartyName); etAddress = findViewById(R.id.etAddress);
        etMobile = findViewById(R.id.etMobile); etGstRate = findViewById(R.id.etGstRate);
        llItemsContainer = findViewById(R.id.llItemsContainer);

        etGstRate.addTextChangedListener(new SimpleWatcher() {
            @Override public void afterTextChanged(Editable s) { recalculateTotals(); }
        });
        findViewById(R.id.btnGst0).setOnClickListener(v -> etGstRate.setText("0"));
        findViewById(R.id.btnGst5).setOnClickListener(v -> etGstRate.setText("5"));
        findViewById(R.id.btnGst12).setOnClickListener(v -> etGstRate.setText("12"));
        findViewById(R.id.btnGst18).setOnClickListener(v -> etGstRate.setText("18"));
        findViewById(R.id.btnGst28).setOnClickListener(v -> etGstRate.setText("28"));
        findViewById(R.id.btnAddItem).setOnClickListener(v -> addItemRow());
        findViewById(R.id.btnSaveBill).setOnClickListener(v -> saveBill(false));
        findViewById(R.id.btnDownloadPdf).setOnClickListener(v -> saveBill(true));
        findViewById(R.id.btnNewBill).setOnClickListener(v -> resetForm());
        findViewById(R.id.btnSavedBills).setOnClickListener(v -> startActivity(new Intent(this, SavedBillsActivity.class)));
        resetForm();
    }

    private void resetForm() {
        currentBillNo = dbHelper.getNextBillNo();
        currentDate = new SimpleDateFormat("dd-MM-yyyy", Locale.getDefault()).format(new Date());
        tvBillMeta.setText("Bill No: " + currentBillNo + " | Date: " + currentDate);
        etPartyName.setText(""); etAddress.setText(""); etMobile.setText(""); etGstRate.setText("18");
        llItemsContainer.removeAllViews(); addItemRow(); recalculateTotals();
    }

    private void addItemRow() {
        View row = LayoutInflater.from(this).inflate(R.layout.item_bill_row, llItemsContainer, false);
        EditText etQty = row.findViewById(R.id.etQty), etRate = row.findViewById(R.id.etRate);
        SimpleWatcher w = new SimpleWatcher() { @Override public void afterTextChanged(Editable s) { recalculateTotals(); } };
        etQty.addTextChangedListener(w); etRate.addTextChangedListener(w);
        row.findViewById(R.id.btnRemoveItem).setOnClickListener(v -> {
            if (llItemsContainer.getChildCount() > 1) { llItemsContainer.removeView(row); updateRowNumbers(); recalculateTotals(); }
            else Toast.makeText(this, "Kam se kam 1 item zaroori hai", Toast.LENGTH_SHORT).show();
        });
        llItemsContainer.addView(row); updateRowNumbers();
    }

    private void updateRowNumbers() {
        for (int i = 0; i < llItemsContainer.getChildCount(); i++) {
            ((TextView) llItemsContainer.getChildAt(i).findViewById(R.id.tvItemNumber)).setText("Item #" + (i + 1));
        }
    }

    private void recalculateTotals() {
        double sub = 0.0;
        for (int i = 0; i < llItemsContainer.getChildCount(); i++) {
            View row = llItemsContainer.getChildAt(i);
            double q = parseDouble(((EditText) row.findViewById(R.id.etQty)).getText().toString());
            double r = parseDouble(((EditText) row.findViewById(R.id.etRate)).getText().toString());
            double amt = q * r;
            ((TextView) row.findViewById(R.id.tvRowAmount)).setText(String.format(Locale.getDefault(), "₹%.2f", amt));
            sub += amt;
        }
        double gstRate = parseDouble(etGstRate.getText().toString());
        double gstAmt = (sub * gstRate) / 100.0;
        tvSubTotal.setText(String.format(Locale.getDefault(), "₹%.2f", sub));
        tvGstAmount.setText(String.format(Locale.getDefault(), "₹%.2f", gstAmt));
        tvGrandTotal.setText(String.format(Locale.getDefault(), "₹%.2f", sub + gstAmt));
    }

    private void saveBill(boolean generatePdf) {
        String party = etPartyName.getText() != null ? etPartyName.getText().toString().trim() : "";
        if (TextUtils.isEmpty(party)) { Toast.makeText(this, "Party Name daalna zaroori hai", Toast.LENGTH_SHORT).show(); return; }
        List<BillItem> items = new ArrayList<>();
        double sub = 0.0;
        for (int i = 0; i < llItemsContainer.getChildCount(); i++) {
            View row = llItemsContainer.getChildAt(i);
            String n = ((EditText) row.findViewById(R.id.etItemName)).getText().toString().trim();
            double q = parseDouble(((EditText) row.findViewById(R.id.etQty)).getText().toString());
            double r = parseDouble(((EditText) row.findViewById(R.id.etRate)).getText().toString());
            if (!TextUtils.isEmpty(n) && q > 0) { BillItem it = new BillItem(n, q, r); items.add(it); sub += it.amount; }
        }
        if (items.isEmpty()) { Toast.makeText(this, "Kam se kam 1 item ka Name aur Qty daalein", Toast.LENGTH_SHORT).show(); return; }

        double gstRate = parseDouble(etGstRate.getText().toString());
        double gstAmt = (sub * gstRate) / 100.0;
        BillModel bill = new BillModel();
        bill.billNo = currentBillNo; bill.billDate = currentDate; bill.partyName = party;
        bill.address = etAddress.getText() != null ? etAddress.getText().toString().trim() : "";
        bill.mobile = etMobile.getText() != null ? etMobile.getText().toString().trim() : "";
        bill.subTotal = sub; bill.gstRate = gstRate; bill.gstAmount = gstAmt;
        bill.grandTotal = sub + gstAmt; bill.items = items;

        dbHelper.insertBill(bill);
        Toast.makeText(this, "Bill Saved (" + bill.billNo + ")!", Toast.LENGTH_SHORT).show();
        currentBillNo = dbHelper.getNextBillNo();
        tvBillMeta.setText("Bill No: " + currentBillNo + " | Date: " + currentDate);
        if (generatePdf) AdsHelper.showInterstitialThen(this, () -> PdfHelper.createAndShowPdf(MainActivity.this, bill));
    }

    private double parseDouble(String s) {
        try { return TextUtils.isEmpty(s) ? 0.0 : Double.parseDouble(s.trim()); } catch (Exception e) { return 0.0; }
    }

    @Override protected void onDestroy() { super.onDestroy(); if (bannerView != null) bannerView.destroy(); }
    private abstract static class SimpleWatcher implements TextWatcher {
        @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
        @Override public void onTextChanged(CharSequence s, int start, int before, int count) {}
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/SavedBillAdapter.java
package com.sales.bill;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.google.android.material.button.MaterialButton;
import java.util.List;
import java.util.Locale;

public class SavedBillAdapter extends RecyclerView.Adapter<SavedBillAdapter.BillVH> {
    public interface Listener { void onPdf(BillModel bill); void onDelete(BillModel bill); }
    private final List<BillModel> list;
    private final Listener listener;
    public SavedBillAdapter(List<BillModel> list, Listener listener) { this.list = list; this.listener = listener; }

    @NonNull @Override
    public BillVH onCreateViewHolder(@NonNull ViewGroup p, int vt) {
        return new BillVH(LayoutInflater.from(p.getContext()).inflate(R.layout.item_saved_bill, p, false));
    }
    @Override
    public void onBindViewHolder(@NonNull BillVH h, int pos) {
        BillModel b = list.get(pos);
        h.tvParty.setText(b.partyName);
        h.tvTotal.setText(String.format(Locale.getDefault(), "₹%.2f", b.grandTotal));
        h.tvInfo.setText(b.billNo + " | " + b.billDate + " | Items: " + b.items.size() + (b.mobile != null && !b.mobile.isEmpty() ? " | " + b.mobile : ""));
        h.btnPdf.setOnClickListener(v -> listener.onPdf(b));
        h.btnDelete.setOnClickListener(v -> listener.onDelete(b));
    }
    @Override public int getItemCount() { return list.size(); }
    static class BillVH extends RecyclerView.ViewHolder {
        TextView tvParty, tvTotal, tvInfo; MaterialButton btnPdf, btnDelete;
        BillVH(@NonNull View v) {
            super(v); tvParty = v.findViewById(R.id.tvSbParty); tvTotal = v.findViewById(R.id.tvSbTotal);
            tvInfo = v.findViewById(R.id.tvSbInfo); btnPdf = v.findViewById(R.id.btnSbPdf); btnDelete = v.findViewById(R.id.btnSbDelete);
        }
    }
}
EOF

cat << 'EOF' > app/src/main/java/com/sales/bill/SavedBillsActivity.java
package com.sales.bill;

import android.os.Bundle;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.unity3d.services.banners.BannerView;
import java.util.ArrayList;
import java.util.List;

public class SavedBillsActivity extends AppCompatActivity {
    private BillDbHelper dbHelper;
    private final List<BillModel> bills = new ArrayList<>();
    private SavedBillAdapter adapter;
    private TextView tvEmpty;
    private BannerView bannerView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_saved_bills);
        dbHelper = new BillDbHelper(this);
        bannerView = AdsHelper.attachBanner(this, (FrameLayout) findViewById(R.id.bannerContainer));
        tvEmpty = findViewById(R.id.tvEmpty);
        RecyclerView rv = findViewById(R.id.rvSavedBills);
        rv.setLayoutManager(new LinearLayoutManager(this));
        findViewById(R.id.btnBack).setOnClickListener(v -> finish());
        adapter = new SavedBillAdapter(bills, new SavedBillAdapter.Listener() {
            @Override public void onPdf(BillModel bill) {
                AdsHelper.showInterstitialThen(SavedBillsActivity.this, () -> PdfHelper.createAndShowPdf(SavedBillsActivity.this, bill));
            }
            @Override public void onDelete(BillModel bill) {
                dbHelper.deleteBill(bill.id); loadBills(); Toast.makeText(SavedBillsActivity.this, "Bill deleted", Toast.LENGTH_SHORT).show();
            }
        });
        rv.setAdapter(adapter);
        loadBills();
    }

    private void loadBills() {
        bills.clear(); bills.addAll(dbHelper.getAllBills());
        tvEmpty.setVisibility(bills.isEmpty() ? View.VISIBLE : View.GONE);
        adapter.notifyDataSetChanged();
    }
    @Override protected void onDestroy() { super.onDestroy(); if (bannerView != null) bannerView.destroy(); }
}
EOF

echo "ALL_DONE"
