Browser extensions
==================

https://developer.chrome.com/docs/extensions/mv2/manifest/

https://developer.chrome.com/docs/extensions/reference/tabs/#method-getCurrent

Browser action
--------------

https://devdocs.io/web_extensions/manifest.json/browser_action

A browser action is a button that your extension adds to the browser's toolbar.

Use browserAction.onClicked.*Listener to implement
an action::

  chrome.browserAction.onClicked.addListener(tab => {...})

tab: https://devdocs.io/web_extensions/api/tabs/tab

Commands
--------

Use the "commands" key in the manifest to create default
keyboard shortcuts for the extension. E.g.::

  "commands": {
    "toggle-feature": {
      "suggested_key": {
        "default": "Alt+Shift+U",
        "linux": "Ctrl+Shift+U"
      },
      "description": "Send a 'toggle-feature' event to the extension"
    },
    "do-another-thing": {
      "suggested_key": {
        "default": "Ctrl+Shift+Y"
      }
    }
  }

In Firefox, users can change shortcuts at
`about:addons <about:addons>`_.
In Chrome, users can change shortcuts at
`chrome://extensions/shortcuts <chrome://extensions/shortcuts>`_.

There are three special names you can use to suggest keyboard
shortcuts for pre-defined actions: _execute_browser_action: works like a click on the extension's browser action.
_execute_page_action: works like a click on the extension's page action.
_execute_sidebar_action: opens the extension's sidebar. Only supported in Firefox 54 and newer.

If you create shortcuts for these, they do NOT trigger command
events when the shortcuts are typed. They invoke the action
directly.

For your own commands, listen in the background for command events::

  chrome.commands.onCommand.addListener(function (command) {
    if (command === "toggle-feature") {
      console.log("Toggling the feature!");
    }
  });
