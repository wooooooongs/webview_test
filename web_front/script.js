const $ = (selector) => document.querySelector(selector);

window.onload = () => {
  const sendButton = $('#send');
  sendButton.addEventListener('click', (e) => {
    const alertInput = $('#name');
    alert(alertInput.value);
    alertInput = '';

    return false;
  });
};

function jsToNativeBridge() {
  let messageToSend = $('#messageToSend');
  const sendData = {
    message: messageToSend.value,
  };

  try {
    // callbackHandler = bridge
    window.webkit.messageHandlers.nativeHandler.postMessage(sendData);
    messageToSend.value = '';
  } catch (err) {
    alert(err);
  }
}

function nativeToJsBridge(message) {
  let nativeInput = $('#nativeInput');
  nativeInput.value = message;
}
