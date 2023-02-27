; RUN: opt -passes=mergefunc -S < %s | FileCheck %s

; This test makes sure that the mergefunc pass does not merge functions
; that have different nonnull assertions.

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

%1 = type ptr

define void @f1(ptr noalias nocapture noundef sret(%1) dereferenceable(8) %0, ptr noalias nocapture noundef dereferenceable(24) %1) {
  ; CHECK-LABEL: @f1(
  ; CHECK: %3 = load ptr, ptr %1, align 8, !nonnull !0
  %3 = load ptr, ptr %1, align 8, !nonnull !0
  store ptr %3, ptr %0, align 8
  ret void
}

define void @f2(ptr noalias nocapture noundef sret(%1) dereferenceable(8) %0, ptr noalias nocapture noundef dereferenceable(24) %1) {
  ; CHECK-LABEL: @f2(
  ; CHECK: %3 = load ptr, ptr %1, align 8
  %3 = load ptr, ptr %1, align 8
  store ptr %3, ptr %0, align 8
  ret void
}

define void @f3(ptr noalias nocapture noundef sret(%1) dereferenceable(8) %0, ptr noalias nocapture noundef dereferenceable(24) %1) {
  ; CHECK-LABEL: @f3(
  ; CHECK: %3 = load ptr, ptr %1, align 8, !noundef !0
  %3 = load ptr, ptr %1, align 8, !noundef !0
  store ptr %3, ptr %0, align 8
  ret void
}

!0 = !{}
