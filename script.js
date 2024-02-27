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

function jsToNativeEventCall() {
  let messageToSend = $('#messageToSend');
  const sendData = { message: messageToSend.value };

  try {
    // callbackHandler = bridge
    window.webkit.messageHandler.callbackHandler.postMessage(sendData);
    messageToSend.value = '';
  } catch (err) {
    alert(err);
  }
}

function nativeToJsEventCall(message) {
  let nativeInput = $('#nativeInput');
  nativeInput.value = message;
}
