#!/bin/bash
#
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Themes
# git clone --depth=1 -b 18.06 https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
# git clone --depth=1 https://github.com/xiaoqingfengATGH/luci-theme-infinityfreedom package/luci-theme-infinityfreedom
# git_sparse_clone main https://github.com/haiibo/packages luci-theme-atmaterial luci-theme-opentomcat luci-theme-netgear

# Alist
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/alist

git_sparse_clone master https://github.com/immortalwrt/immortalwrt package/emortal/automount

./scripts/feeds update -a && ./scripts/feeds install -a

find package/*/ -maxdepth 2 -path "*/Makefile" | xargs -i sed -i 's/..\/..\/luci.mk/$(TOPDIR)\/feeds\/luci\/luci.mk/g' {}

sed -i 's/PKG_VERSION:=1.37.0/PKG_VERSION:=1.36.0/' feeds/packages/net/aria2/Makefile
sed -i 's/^PKG_HASH:=.*$/PKG_HASH:=58d1e7608c12404f0229a3d9a4953d0d00c18040504498b483305bcb3de907a5/' feeds/packages/net/aria2/Makefile


