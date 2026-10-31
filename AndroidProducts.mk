# cappu Android 12 产品入口：替代 Android 8 的 add_lunch_combo，直接注册本地产品，
# 防止 envsetup 误调用 roomservice 下载不匹配的设备树。eng 是本次调试目标。
PRODUCT_MAKEFILES := lineage_cappu:$(LOCAL_DIR)/lineage.mk

COMMON_LUNCH_CHOICES := \
    lineage_cappu-eng \
    lineage_cappu-userdebug \
    lineage_cappu-user
