import React, { Component, Fragment } from 'react'
import { Toast } from '@shopify/app-bridge/actions'

export function useFlashMessage(shopify_app, toastOptions, setShow) {
  const call = function() {
    if (window.location.hostname.indexOf("shopify") >= 0 ||
      window.location.hostname.indexOf("newapp.com") >= 0) {
        Toast.create(shopify_app, toastOptions);
    }
    else {
      setShow(true);
    }
  }
  return { createFlashMessage: call };
}
