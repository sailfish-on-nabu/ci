#!/bin/bash
source hadk.env
cd $ANDROID_ROOT
source build/envsetup.sh 2>&1
breakfast $DEVICE

# jdk
# /usr/lib/jvm/java-8-openjdk-amd64/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar


# hack for droidmedia
cd $ANDROID_ROOT/external/droidmedia
git checkout 0.20230605.1
echo 'MINIMEDIA_AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk
echo 'AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk

cd $ANDROID_ROOT
# hybris-patches
./hybris-patches/apply-patches.sh --mb
mkdir -p out/host/linux-x86/bin/
cp ./prebuilts/misc/linux-x86/libufdt/mkdtimg out/host/linux-x86/bin/mkdtimg

export TEMPORARY_DISABLE_PATH_RESTRICTIONS=true
make -j$(nproc --all) hybris-hal droidmedia