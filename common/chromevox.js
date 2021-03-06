// Copyright 2013 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * @preserve
 * @filename common/chromevox.js
 */

/**
 * @fileoverview Defines a global object. The initialization of this
 *   object happens in init.js.
 *
 * @author dmazzoni@google.com (Dominic Mazzoni)
 */

goog.provide('cvox.ChromeVox');

// Forward declarations.
// TODO (stoarca): Put these in a separate file and pass that
// into the build system instead of having it here. This will allow
// us to group all of the forward declarations for each file without
// having them overwrite the mapping in deps.js
goog.addDependency(
    '../host/interface/abstract_host.js',
    ['cvox.AbstractHost'],
    []);

goog.addDependency(
    '../host/interface/tts_interface.js',
    ['cvox.TtsInterface'],
    []);

goog.addDependency(
    '../host/interface/braille_interface.js',
    ['cvox.BrailleInterface'],
    []);

goog.addDependency(
    '../host/interface/mathjax_interface.js',
    ['cvox.MathJaxInterface'],
    []);

goog.addDependency(
    '../host/interface/abstract_msgs.js',
    ['cvox.AbstractMsgs'],
    []);

goog.addDependency(
    '../host/interface/abstract_earcons.js',
    ['cvox.AbstractEarcons'],
    []);

goog.addDependency(
    '../chromevox/common/key_sequence.js',
    ['cvox.KeySequence'],
    []);

goog.addDependency(
    '../chromevox/injected/navigation_manager.js',
    ['cvox.NavigationManager'],
    []);

goog.addDependency(
    '../chromevox/injected/serializer.js',
    ['cvox.Serializer'],
    []);

// Constants
/**
 * Constant for verbosity setting (cvox.ChromeVox.verbosity).
 * @const
 * @type {number}
 */
cvox.VERBOSITY_VERBOSE = 0;
/**
 * Constant for verbosity setting (cvox.ChromeVox.verbosity).
 * @const
 * @type {number}
 */
cvox.VERBOSITY_BRIEF = 1;


/**
 * @constructor
 */
cvox.ChromeVox = function() {};

/**
 * @type {cvox.AbstractHost}
 */
cvox.ChromeVox.host = null;
/**
 * @type {cvox.TtsInterface}
 * @preserve
 */
cvox.ChromeVox.tts;
/**
 * @type {cvox.BrailleInterface}
 * @preserve
 */
cvox.ChromeVox.braille;
/**
 * @type {cvox.MathJaxInterface}
 * @preserve
 */
cvox.ChromeVox.mathJax;
/**
 * @type {cvox.AbstractMsgs}
 */
cvox.ChromeVox.msgs = null;
/**
 * @type {boolean}
 */
cvox.ChromeVox.isActive = true;
/**
 * @type {?string}
 */
cvox.ChromeVox.version = null;
/**
 * @type {cvox.AbstractEarcons}
 */
cvox.ChromeVox.earcons = null;
/**
 * @type {cvox.NavigationManager}
 */
cvox.ChromeVox.navigationManager = null;
/**
 * @type {cvox.Serializer}
 */
cvox.ChromeVox.serializer = null;
/**
 * @type {boolean}
 */
cvox.ChromeVox.isStickyOn = false;
/**
 * @type {boolean}
 */
cvox.ChromeVox.keyPrefixOn = false;
/**
 * Verbosity setting.
 * See: cvox.VERBOSITY_VERBOSE and cvox.VERBOSITY_BRIEF
 * @type {number}
 */
cvox.ChromeVox.verbosity = cvox.VERBOSITY_VERBOSE;
/**
 * @type {number}
 */
cvox.ChromeVox.typingEcho = 0;
/**
 * Echoing on key press events.
 * @type {Object.<string, boolean>}
 */
cvox.ChromeVox.keyEcho = {};
/**
 * @type {Object.<string, {x:number, y:number}>}
 */
cvox.ChromeVox.position = {};
/**
 * @type {boolean}
 */
cvox.ChromeVox.isChromeOS = navigator.userAgent.indexOf('CrOS') != -1;
/**
 * @type {boolean}
 */
cvox.ChromeVox.isMac = navigator.platform.indexOf('Mac') != -1;
/**
 * @type {string}
 * TODO (clchen): This logic is already in prefs.js;
 * clean it up to avoid code duplication.
 */
if (cvox.ChromeVox.isChromeOS)
  cvox.ChromeVox.modKeyStr = 'Shift+Search';
else if (cvox.ChromeVox.isMac)
  cvox.ChromeVox.modKeyStr = 'Ctrl+Cmd';
else
  cvox.ChromeVox.modKeyStr = 'Ctrl+Alt';
/**
 * If any of these keys is pressed with the modifier key, we go in sequence mode
 * where the subsequent independent key downs (while modifier keys are down)
 * are a part of the same shortcut. This array is populated in
 * cvox.ChromeVoxKbHandler.loadKeyToFunctionsTable().
 * @type {!Array.<cvox.KeySequence>}
 */
cvox.ChromeVox.sequenceSwitchKeyCodes = [];
/** @type {Object.<string, boolean>} */
cvox.ChromeVox.visitedUrls = {};
/**
 * This function can be called before doing an operation that may trigger
 * focus events and other events that would normally be announced. This
 * tells the event manager that these events should be ignored, they're
 * a result of another command that's already announced them. This is
 * a temporary state that's automatically reverted after a few milliseconds,
 * there's no way to explicitly "un-mark".
 * @type {Function}
 */
cvox.ChromeVox.markInUserCommand = function() {};
/**
 * Synchronizes ChromeVox's internal cursor to the targetNode.
 * @param {Node} targetNode The node that ChromeVox should be synced to.
 * @param {boolean=} speakNode If true, speaks out the node.
 * @param {number?} opt_queueMode The queue mode to use for speaking.
 */
cvox.ChromeVox.syncToNode = function(
    targetNode, speakNode, opt_queueMode) {};

/**
 * Speaks the given node.
 * @param {Node} targetNode The node that ChromeVox should be synced to.
 * @param {number=} queueMode The queue mode to use for speaking.
 * @param {Object=} properties Speech properties to use for this utterance.
 */
cvox.ChromeVox.speakNode = function(targetNode, queueMode, properties) {};

/**
 * Provide a way for modules that can't depend on cvox.ChromeVoxUserCommands
 * to execute commands.
 *
 * @param {string} commandName The command name as a string.
 */
cvox.ChromeVox.executeUserCommand = function(commandName) {};

/**
 * True if the document body has aria-hidden='true' when we first load.
 * ChromeVox will disallow any navigation and not eat any keystrokes.
 * @type {boolean}
 */
cvox.ChromeVox.entireDocumentIsHidden = false;

/**
 * Stores state variables in a provided object.
 *
 * @param {Object} store The object.
 */
cvox.ChromeVox.storeOn = function(store) {
  store['isStickyOn'] = cvox.ChromeVox.isStickyOn;
  cvox.ChromeVox.navigationManager.storeOn(store);
};

/**
 * Updates the object with state variables from an earlier storeOn call.
 *
 * @param {Object} store The object.
 */
cvox.ChromeVox.readFrom = function(store) {
  cvox.ChromeVox.isStickyOn = store['isStickyOn'];
  cvox.ChromeVox.navigationManager.readFrom(store);
};
