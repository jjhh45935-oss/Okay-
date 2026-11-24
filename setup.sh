#!/bin/bash
set -e

mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/xml
mkdir -p app/src/main/java/com/sales/bill

cat << 'EOF' > settings.gradle
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
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
        release {
            minifyEnabled false
        }
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

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity
            android:name=".SavedBillsActivity"
            android:exported="false" />

        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="com.sales.bill.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
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
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path
        android:fillColor="#1E40AF"
        android:pathData="M12,2A10,10 0 1,0 22,12A10,10 0 0,0 12,2Z" />
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M7,6H17V18L15,16.5L13,18L11,16.5L9,18L7,16.5V6ZM9,9V10.5H15V9H9ZM9,12V13.5H15V12H9Z" />
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
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/bg_light"
    android:orientation="vertical">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:background="@color/primary"
        android:gravity="center_vertical"
        android:orientation="horizontal"
        android:padding="14dp">

        <LinearLayout
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:orientation="vertical">

            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="Sales Bill Voucher"
                android:textColor="@color/white"
                android:textSize="19sp"
                android:textStyle="bold" />

            <TextView
                android:id="@+id/tvBillMeta"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="Bill No: INV-1001 | Date: --"
                android:textColor="#DBEAFE"
                android:textSize="12sp" />
        </LinearLayout>

        <com.google.android.material.button.MaterialButton
            android:id="@+id/btnSavedBills"
            style="@style/Widget.MaterialComponents.Button.OutlinedButton"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:text="Saved Bills"
            android:textAllCaps="false"
            android:textColor="@color/white"
            app:strokeColor="@color/white" />
    </LinearLayout>

    <FrameLayout
        android:id="@+id/bannerContainer"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:background="@color/white"
        android:paddingVertical="2dp" />

    <View
        android:layout_width="match_parent"
        android:layout_height="1dp"
        android:background="@color/divider" />

    <ScrollView
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1">

        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:orientation="vertical"
            android:padding="12dp">

            <com.google.android.material.card.MaterialCardView
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                app:cardCornerRadius="12dp"
                app:cardElevation="2dp">

                <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="vertical"
                    android:padding="14dp">

                    <TextView
                        android:layout_width="wrap_content"
                        android:layout_height="wrap_content"
                        android:text="Party Details"
                        android:textColor="@color/primary"
                        android:textSize="15sp"
                        android:textStyle="bold" />

                    <com.google.android.material.textfield.TextInputLayout
                        style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox"
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:layout_marginTop="8dp"
                        android:hint="Party Name *">

                        <com.google.android.material.textfield.TextInputEditText
                            android:id="@+id/etPartyName"
                            android:layout_width="match_parent"
                            android:layout_height="wrap_content"
                            android:inputType="textPersonName" />
                    </com.google.android.material.textfield.TextInputLayout>

                    <com.google.android.material.textfield.TextInputLayout
                        style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox"
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:layout_marginTop="8dp"
                        android:hint="Address">

                        <com.google.android.material.textfield.TextInputEditText
                            android:id="@+id/etAddress"
                            android:layout_width="match_parent"
                            android:layout_height="wrap_content"
                            android:inputType="textPostalAddress" />
                    </com.google.android.material.textfield.TextInputLayout>

                    <com.google.android.material.textfield.TextInputLayout
                        style="@style/Widget.MaterialComponents.TextInputLayout.OutlinedBox"
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:layout_marginTop="8dp"
                        android:hint="Mobile Number">

                        <com.google.android.material.textfield.TextInputEditText
                            android:id="@+id/etMobile"
                            android:layout_width="match_parent"
                            android:layout_height="wrap_content"
                            android:inputType="phone"
                            android:maxLength="15" />
                    </com.google.android.material.textfield.TextInputLayout>
                </LinearLayout>
            </com.google.android.material.card.MaterialCardView>

            <View
                android:layout_width="match_parent"
                android:layout_height="2dp"
                android:layout_marginVertical="14dp"
                android:background="@color/primary" />

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:layout_marginBottom="8dp"
                android:gravity="center_vertical"
                android:orientation="horizontal">

                <TextView
                    android:layout_width="0dp"
                    android:layout_height="wrap_content"
                    android:layout_weight="1"
                    android:text="Items List"
                    android:textColor="@color/text_dark"
                    android:textSize="16sp"
                    android:textStyle="bold" />

                <com.google.android.material.button.MaterialButton
                    android:id="@+id/btnAddItem"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="+ Add Item"
                    android:textAllCaps="false"
                    app:cornerRadius="8dp" />
            </LinearLayout>

            <LinearLayout
                android:id="@+id/llItemsContainer"
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical" />

            <com.google.android.material.card.MaterialCardView
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:layout_marginTop="8dp"
                app:cardCornerRadius="12dp"
                app:cardElevation="2dp">

                <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="vertical"
                    android:padding="14dp">

                    <LinearLayout
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:orientation="horizontal">

                        <TextView
                            android:layout_width="0dp"
                            android:layout_height="wrap_content"
                            android:layout_weight="1"
                            android:text="Sub Total:"
                            android:textColor="@color/text_dark"
                            android:textSize="15sp" />

                        <TextView
                            android:id="@+id/tvSubTotal"
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:text="₹0.00"
                            android:textColor="@color/text_dark"
                            android:textSize="15sp"
                            android:textStyle="bold" />
                    </LinearLayout>

                    <LinearLayout
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:layout_marginTop="10dp"
                        android:gravity="center_vertical"
                        android:orientation="horizontal">

                        <TextView
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:text="GST Rate (%):"
                            android:textColor="@color/text_dark"
                            android:textSize="14sp" />

                        <EditText
                            android:id="@+id/etGstRate"
                            android:layout_width="70dp"
                            android:layout_height="wrap_content"
                            android:layout_marginStart="8dp"
                            android:background="@android:drawable/edit_text"
                            android:gravity="center"
                            android:inputType="numberDecimal"
                            android:padding="6dp"
                            android:text="18"
                            android:textSize="14sp" />

                        <TextView
                            android:id="@+id/tvGstAmount"
                            android:layout_width="0dp"
                            android:layout_height="wrap_content"
                            android:layout_weight="1"
                            android:gravity="end"
                            android:text="₹0.00"
                            android:textColor="@color/text_gray"
                            android:textSize="14sp"
                            android:textStyle="bold" />
                    </LinearLayout>

                    <LinearLayout
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:layout_marginTop="8dp"
                        android:orientation="horizontal">

                        <Button
                            android:id="@+id/btnGst0"
                            style="?android:attr/buttonBarButtonStyle"
                            android:layout_width="0dp"
                            android:layout_height="36dp"
                            android:layout_weight="1"
                            android:text="0%"
                            android:textSize="12sp" />

                        <Button
                            android:id="@+id/btnGst5"
                            style="?android:attr/buttonBarButtonStyle"
                            android:layout_width="0dp"
                            android:layout_height="36dp"
                            android:layout_weight="1"
                            android:text="5%"
                            android:textSize="12sp" />

                        <Button
                            android:id="@+id/btnGst12"
                            style="?android:attr/buttonBarButtonStyle"
                            android:layout_width="0dp"
                            android:layout_height="36dp"
                            android:layout_weight="1"
                            android:text="12%"
                            android:textSize="12sp" />

                        <Button
                            android:id="@+id/btnGst18"
                            style="?android:attr/buttonBarButtonStyle"
                            android:layout_width="0dp"
                            android:layout_height="36dp"
                            android:layout_weight="1"
                            android:text="18%"
                            android:textSize="12sp" />

                        <Button
                            android:id="@+id/btnGst28"
                            style="?android:attr/buttonBarButtonStyle"
                            android:layout_width="0dp"
                            android:layout_height="36dp"
                            android:layout_weight="1"
                            android:text="28%"
                            android:textSize="12sp" />
                    </LinearLayout>

                    <View
                        android:layout_width="match_parent"
                        android:layout_height="1dp"
                        android:layout_marginVertical="10dp"
                        android:background="@color/divider" />

                    <LinearLayout
                        android:layout_width="match_parent"
                        android:layout_height="wrap_content"
                        android:orientation="horizontal">

                        <TextView
                            android:layout_width="0dp"
                            android:layout_height="wrap_content"
                            android:layout_weight="1"
                            android:text="Grand Total:"
                            android:textColor="@color/primary"
                            android:textSize="18sp"
                            android:textStyle="bold" />

                        <TextView
                            android:id="@+id/tvGrandTotal"
                            android:layout_width="wrap_content"
                            android:layout_height="wrap_content"
                            android:text="₹0.00"
                            android:textColor="@color/accent"
                            android:textSize="20sp"
                            android:textStyle="bold" />
                    </LinearLayout>
                </LinearLayout>
            </com.google.android.material.card.MaterialCardView>

      
