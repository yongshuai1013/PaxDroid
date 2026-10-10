# PaxDroid QEMU 集成計劃

## 目標
iOS 上的輕量 QEMU 虛擬機，跑 Alpine Linux，比 UTM 簡單。

## 參考
- Podroid：Android 上的 QEMU + Alpine，已驗證 TCG 可用
- Husk：iOS 上的 QEMU（dylib 形式）

## 架構
```
PaxDroid App (SwiftUI)
  └─ QEMURunner (Swift)
      └─ libqemu-system-aarch64.dylib (C)
          └─ Alpine Linux Guest
              └─ Xvnc (顯示)
```

## 步驟
1. [ ] 交叉編譯 QEMU 11 for iOS (aarch64)
   - --target-list=aarch64-softmmu
   - --enable-tcg --disable-kvm
   - 16KB 頁對齊
   - 輸出為 .dylib（iOS 不能 fork 子進程）

2. [ ] 準備 Alpine rootfs
   - 從官方 alpine-minirootfs 下載
   - 用 apk 安裝必要包
   - 打包成 squashfs

3. [ ] 編譯內核
   - Linux 7.x，virt 目標
   - 驅動全內置（virtio-blk, virtio-net 等）

4. [ ] Swift 集成
   - QEMURunner.swift：啟動/停止/配置
   - VNC 客戶端顯示

5. [ ] UI
   - 系統列表（已做）
   - 啟動頁顯示 VNC 畫面

## 狀態
- [x] 研究完成
- [x] UI 基礎完成
- [ ] QEMU 編譯（待開始）
