
# Copyright 2012 Google Inc. All Rights Reserved.
#
# ChromeVox requires the closure compiler and the rhino JS intepreter.
#


CLOSURE_ROOT=/usr/local/lib/closure

# On Debian, rhino is available through apt-get.
RHINO=rhino


# The closure compiler is available at http://code.google.com/closure/compiler/
CLOSURE_COMPILER=java -jar $(CLOSURE_ROOT)/compiler.jar --manage_closure_dependencies

# The closure DepsWriter, available at
#     http://code.google.com/closure/library/docs/depswriter.html
DEPSWRITER=python $(CLOSURE_ROOT)/depswriter.py

#######################################

# A function to return a unique set of file names.
uniq = $(if $(word 1, $(1)), $(call uniq2, $(1)), $(1))
uniq2 = $(firstword $(1)) $(call uniq, $(filter-out $(firstword $(1)), $(wordlist 2, $(words $(1)), $(1))))


deps.js: # empty
	@echo Building Javascript dependencies deps.js
	@$(DEPSWRITER) --root_with_prefix=". ../" >deps.js

CHROMEVOX_manifest_manifest_gen_passthru_SRCS = chromevox/manifest_compiled.json
CHROMEVOX_manifest_manifest_gen_passthru_FILES = chromevox/manifest_compiled_manifest/manifest.json
chromevox/manifest_compiled_manifest/manifest.json: $(CHROMEVOX_manifest_manifest_gen_passthru_SRCS)
	@echo Generating file chromevox/manifest_compiled_manifest/manifest.json
	@mkdir -p $(dir chromevox/manifest_compiled_manifest/manifest.json)
	@cat $< >$@


CHROMEVOX_manifest_compiled_manifest/manifest.json_FILES = $(CHROMEVOX_manifest_manifest_gen_passthru_FILES)
CLOSURE_base_FILES = closure/base.js

CHROMEVOX_MESSAGES_messages_DEPS = $(CLOSURE_base_FILES)
CHROMEVOX_MESSAGES_messages_SRCS = chromevox/messages/messages.js
CHROMEVOX_MESSAGES_messages_FILES = $(CHROMEVOX_MESSAGES_messages_DEPS) $(CHROMEVOX_MESSAGES_messages_SRCS)

CLOSURE_JSON_json_FILES = external/closure_json.js

CHROME_extensions_i18n_DEPS = $(call uniq, $(CLOSURE_JSON_json_FILES) $(CLOSURE_base_FILES))
CHROME_extensions_i18n_SRCS = external/extensions_i18n.js
CHROME_extensions_i18n_FILES = $(CHROME_extensions_i18n_DEPS) $(CHROME_extensions_i18n_SRCS)

CHROME_messages_wrapper_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROME_extensions_i18n_FILES))
CHROME_messages_wrapper_SRCS = external/messages_wrapper.js
CHROME_messages_wrapper_FILES = $(CHROME_messages_wrapper_DEPS) $(CHROME_messages_wrapper_SRCS)

CHROMEVOX_MESSAGES_i18n_messages_messages_jslib_DEPS = $(call uniq, $(CHROMEVOX_MESSAGES_messages_FILES) $(CHROME_messages_wrapper_FILES))
CHROMEVOX_MESSAGES_i18n_messages_messages_jslib_FILES = $(CHROMEVOX_MESSAGES_i18n_messages_messages_jslib_DEPS)

CHROMEVOX_MESSAGES_i18n_messages_localized__en_DEPS = $(CHROMEVOX_MESSAGES_i18n_messages_messages_jslib_FILES)
chromevox/messages/i18n_messages_localized__en.js_FILES = chromevox/messages/i18n_messages_localized__en.js
chromevox/messages/i18n_messages_localized__en.js: $(CHROMEVOX_MESSAGES_i18n_messages_localized__en_DEPS)
	@echo Building Javascript binary chromevox/messages/i18n_messages_localized__en.js
	@$(CLOSURE_COMPILER) --js $(CHROMEVOX_MESSAGES_i18n_messages_localized__en_DEPS) --js_output_file chromevox/messages/i18n_messages_localized__en.js


CHROMEVOX_MESSAGES_i18n_messages_localized__en.js_FILES = chromevox/messages/i18n_messages_localized__en.js
CHROMEVOX_MESSAGES_messages_en.json_SRCS = $(CHROMEVOX_MESSAGES_i18n_messages_localized__en.js_FILES)
CHROMEVOX_MESSAGES_messages_en.json_FILES = chromevox/messages/_locales/en/messages.json
chromevox/messages/_locales/en/messages.json: $(CHROMEVOX_MESSAGES_messages_en.json_SRCS)
	@echo Generating file chromevox/messages/_locales/en/messages.json
	@mkdir -p $(dir chromevox/messages/_locales/en/messages.json)
	@$(RHINO) $(CHROMEVOX_MESSAGES_messages_en.json_SRCS) > $(CHROMEVOX_MESSAGES_messages_en.json_FILES)


CHROMEVOX_MESSAGES__locales/en/messages.json_FILES = $(CHROMEVOX_MESSAGES_messages_en.json_FILES)
CHROMEVOX_MESSAGES_i18n_messages_filegroup_FILES = $(CHROMEVOX_MESSAGES__locales/en/messages.json_FILES)
CHROMEVOX_MESSAGES_i18n_messages_filegroup: $(CHROMEVOX_MESSAGES_i18n_messages_filegroup_FILES)

HOST_INTERFACE_abstract_msgs_DEPS = $(CLOSURE_base_FILES)
HOST_INTERFACE_abstract_msgs_SRCS = host/interface/abstract_msgs.js
HOST_INTERFACE_abstract_msgs_FILES = $(HOST_INTERFACE_abstract_msgs_DEPS) $(HOST_INTERFACE_abstract_msgs_SRCS)

HOST_INTERFACE_abstract_earcons_DEPS = $(CLOSURE_base_FILES)
HOST_INTERFACE_abstract_earcons_SRCS = host/interface/abstract_earcons.js
HOST_INTERFACE_abstract_earcons_FILES = $(HOST_INTERFACE_abstract_earcons_DEPS) $(HOST_INTERFACE_abstract_earcons_SRCS)

HOST_INTERFACE_abstract_host_DEPS = $(CLOSURE_base_FILES)
HOST_INTERFACE_abstract_host_SRCS = host/interface/abstract_host.js
HOST_INTERFACE_abstract_host_FILES = $(HOST_INTERFACE_abstract_host_DEPS) $(HOST_INTERFACE_abstract_host_SRCS)

HOST_INTERFACE_tts_interface_DEPS = $(CLOSURE_base_FILES)
HOST_INTERFACE_tts_interface_SRCS = host/interface/tts_interface.js
HOST_INTERFACE_tts_interface_FILES = $(HOST_INTERFACE_tts_interface_DEPS) $(HOST_INTERFACE_tts_interface_SRCS)

HOST_INTERFACE_abstract_tts_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_tts_interface_FILES))
HOST_INTERFACE_abstract_tts_SRCS = host/interface/abstract_tts.js
HOST_INTERFACE_abstract_tts_FILES = $(HOST_INTERFACE_abstract_tts_DEPS) $(HOST_INTERFACE_abstract_tts_SRCS)

HOST_INTERFACE_host_factory_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(HOST_INTERFACE_abstract_host_FILES) $(HOST_INTERFACE_abstract_msgs_FILES) $(HOST_INTERFACE_abstract_tts_FILES))
HOST_INTERFACE_host_factory_SRCS = host/interface/host_factory.js
HOST_INTERFACE_host_factory_FILES = $(HOST_INTERFACE_host_factory_DEPS) $(HOST_INTERFACE_host_factory_SRCS)

HOST_CHROME_msgs_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_msgs_FILES) $(HOST_INTERFACE_host_factory_FILES))
HOST_CHROME_msgs_SRCS = host/chrome/msgs.js
HOST_CHROME_msgs_FILES = $(HOST_CHROME_msgs_DEPS) $(HOST_CHROME_msgs_SRCS)

CHROMEVOX_INJECTED_console_tts_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(HOST_INTERFACE_tts_interface_FILES))
CHROMEVOX_INJECTED_console_tts_SRCS = chromevox/injected/console_tts.js
CHROMEVOX_INJECTED_console_tts_FILES = $(CHROMEVOX_INJECTED_console_tts_DEPS) $(CHROMEVOX_INJECTED_console_tts_SRCS)

COMMON_chromevox_DEPS = $(CLOSURE_base_FILES)
COMMON_chromevox_SRCS = common/chromevox.js
COMMON_chromevox_FILES = $(COMMON_chromevox_DEPS) $(COMMON_chromevox_SRCS)

COMMON_composite_tts_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_tts_interface_FILES))
COMMON_composite_tts_SRCS = common/composite_tts.js
COMMON_composite_tts_FILES = $(COMMON_composite_tts_DEPS) $(COMMON_composite_tts_SRCS)

COMMON_cursor_DEPS = $(CLOSURE_base_FILES)
COMMON_cursor_SRCS = common/cursor.js
COMMON_cursor_FILES = $(COMMON_cursor_DEPS) $(COMMON_cursor_SRCS)

CHROMEVOX_INJECTED_event_suspender_DEPS = $(CLOSURE_base_FILES)
CHROMEVOX_INJECTED_event_suspender_SRCS = chromevox/injected/event_suspender.js
CHROMEVOX_INJECTED_event_suspender_FILES = $(CHROMEVOX_INJECTED_event_suspender_DEPS) $(CHROMEVOX_INJECTED_event_suspender_SRCS)

COMMON_aria_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(COMMON_chromevox_FILES))
COMMON_aria_util_SRCS = common/aria_util.js
COMMON_aria_util_FILES = $(COMMON_aria_util_DEPS) $(COMMON_aria_util_SRCS)

COMMON_xpath_util_DEPS = $(CLOSURE_base_FILES)
COMMON_xpath_util_SRCS = common/xpath_util.js
COMMON_xpath_util_FILES = $(COMMON_xpath_util_DEPS) $(COMMON_xpath_util_SRCS)

COMMON_dom_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_event_suspender_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(COMMON_aria_util_FILES) $(COMMON_chromevox_FILES) $(COMMON_xpath_util_FILES))
COMMON_dom_util_SRCS = common/dom_util.js
COMMON_dom_util_FILES = $(COMMON_dom_util_DEPS) $(COMMON_dom_util_SRCS)

COMMON_traverse_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_FILES) $(COMMON_dom_util_FILES))
COMMON_traverse_util_SRCS = common/traverse_util.js
COMMON_traverse_util_FILES = $(COMMON_traverse_util_DEPS) $(COMMON_traverse_util_SRCS)

COMMON_content_editable_extractor_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_FILES) $(COMMON_traverse_util_FILES))
COMMON_content_editable_extractor_SRCS = common/content_editable_extractor.js
COMMON_content_editable_extractor_FILES = $(COMMON_content_editable_extractor_DEPS) $(COMMON_content_editable_extractor_SRCS)

COMMON_editable_text_area_shadow_DEPS = $(CLOSURE_base_FILES)
COMMON_editable_text_area_shadow_SRCS = common/editable_text_area_shadow.js
COMMON_editable_text_area_shadow_FILES = $(COMMON_editable_text_area_shadow_DEPS) $(COMMON_editable_text_area_shadow_SRCS)

COMMON_editable_text_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_content_editable_extractor_FILES) $(COMMON_dom_util_FILES) $(COMMON_editable_text_area_shadow_FILES))
COMMON_editable_text_SRCS = common/editable_text.js
COMMON_editable_text_FILES = $(COMMON_editable_text_DEPS) $(COMMON_editable_text_SRCS)

HOST_CHROME_earcons_background_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_earcons_FILES))
HOST_CHROME_earcons_background_SRCS = host/chrome/earcons_background.js
HOST_CHROME_earcons_background_FILES = $(HOST_CHROME_earcons_background_DEPS) $(HOST_CHROME_earcons_background_SRCS)

COMMON_chromevox_json_DEPS = $(CLOSURE_base_FILES)
COMMON_chromevox_json_SRCS = common/chromevox_json.js
COMMON_chromevox_json_FILES = $(COMMON_chromevox_json_DEPS) $(COMMON_chromevox_json_SRCS)

HOST_CHROME_extension_bridge_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_json_FILES))
HOST_CHROME_extension_bridge_SRCS = host/chrome/extension_bridge.js
HOST_CHROME_extension_bridge_FILES = $(HOST_CHROME_extension_bridge_DEPS) $(HOST_CHROME_extension_bridge_SRCS)

HOST_CHROME_tts_background_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES) $(HOST_INTERFACE_abstract_tts_FILES))
HOST_CHROME_tts_background_SRCS = host/chrome/tts_background.js
HOST_CHROME_tts_background_FILES = $(HOST_CHROME_tts_background_DEPS) $(HOST_CHROME_tts_background_SRCS)

CHROMEVOX_BACKGROUND_accessibility_api_handler_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_editable_text_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(HOST_INTERFACE_abstract_tts_FILES))
CHROMEVOX_BACKGROUND_accessibility_api_handler_SRCS = chromevox/background/accessibility_api_handler.js
CHROMEVOX_BACKGROUND_accessibility_api_handler_FILES = $(CHROMEVOX_BACKGROUND_accessibility_api_handler_DEPS) $(CHROMEVOX_BACKGROUND_accessibility_api_handler_SRCS)

CHROMEVOX_BACKGROUND_injected_script_loader_DEPS = $(CLOSURE_base_FILES)
CHROMEVOX_BACKGROUND_injected_script_loader_SRCS = chromevox/background/injected_script_loader.js
CHROMEVOX_BACKGROUND_injected_script_loader_FILES = $(CHROMEVOX_BACKGROUND_injected_script_loader_DEPS) $(CHROMEVOX_BACKGROUND_injected_script_loader_SRCS)

COMMON_key_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES))
COMMON_key_util_SRCS = common/key_util.js
COMMON_key_util_FILES = $(COMMON_key_util_DEPS) $(COMMON_key_util_SRCS)

CHROMEVOX_BACKGROUND_KEYMAPS_key_map_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_key_util_FILES))
CHROMEVOX_BACKGROUND_KEYMAPS_key_map_SRCS = chromevox/background/keymaps/key_map.js
CHROMEVOX_BACKGROUND_KEYMAPS_key_map_FILES = $(CHROMEVOX_BACKGROUND_KEYMAPS_key_map_DEPS) $(CHROMEVOX_BACKGROUND_KEYMAPS_key_map_SRCS)

COMMON_command_store_DEPS = $(CLOSURE_base_FILES)
COMMON_command_store_SRCS = common/command_store.js
COMMON_command_store_FILES = $(COMMON_command_store_DEPS) $(COMMON_command_store_SRCS)

HOST_CHROME_earcons_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(HOST_INTERFACE_host_factory_FILES) $(HOST_CHROME_extension_bridge_FILES))
HOST_CHROME_earcons_SRCS = host/chrome/earcons.js
HOST_CHROME_earcons_FILES = $(HOST_CHROME_earcons_DEPS) $(HOST_CHROME_earcons_SRCS)

COMMON_buildinfo_DEPS = $(CLOSURE_base_FILES)
COMMON_buildinfo_SRCS = common/buildinfo.js
COMMON_buildinfo_FILES = $(COMMON_buildinfo_DEPS) $(COMMON_buildinfo_SRCS)

CHROMEVOX_INJECTED_api_util_DEPS = $(CLOSURE_base_FILES)
CHROMEVOX_INJECTED_api_util_SRCS = chromevox/injected/api_util.js
CHROMEVOX_INJECTED_api_util_FILES = $(CHROMEVOX_INJECTED_api_util_DEPS) $(CHROMEVOX_INJECTED_api_util_SRCS)

CHROMEVOX_INJECTED_script_installer_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_dom_util_FILES))
CHROMEVOX_INJECTED_script_installer_SRCS = chromevox/injected/script_installer.js
CHROMEVOX_INJECTED_script_installer_FILES = $(CHROMEVOX_INJECTED_script_installer_DEPS) $(CHROMEVOX_INJECTED_script_installer_SRCS)

CHROMEVOX_INJECTED_api_implementation_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_aria_util_FILES) $(COMMON_buildinfo_FILES) $(COMMON_chromevox_FILES) $(COMMON_chromevox_json_FILES) $(COMMON_dom_util_FILES) $(CHROMEVOX_INJECTED_api_util_FILES) $(CHROMEVOX_INJECTED_script_installer_FILES))
CHROMEVOX_INJECTED_api_implementation_SRCS = chromevox/injected/api_implementation.js
CHROMEVOX_INJECTED_api_implementation_FILES = $(CHROMEVOX_INJECTED_api_implementation_DEPS) $(CHROMEVOX_INJECTED_api_implementation_SRCS)

CHROMEVOX_INJECTED_node_breadcrumb_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES))
CHROMEVOX_INJECTED_node_breadcrumb_SRCS = chromevox/injected/node_breadcrumb.js
CHROMEVOX_INJECTED_node_breadcrumb_FILES = $(CHROMEVOX_INJECTED_node_breadcrumb_DEPS) $(CHROMEVOX_INJECTED_node_breadcrumb_SRCS)

CHROMEVOX_INJECTED_history_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_dom_util_FILES) $(CHROMEVOX_INJECTED_node_breadcrumb_FILES))
CHROMEVOX_INJECTED_history_SRCS = chromevox/injected/history.js
CHROMEVOX_INJECTED_history_FILES = $(CHROMEVOX_INJECTED_history_DEPS) $(CHROMEVOX_INJECTED_history_SRCS)

AXSJAX_COMMON_AxsJAX_DEPS = $(CLOSURE_base_FILES)
AXSJAX_COMMON_AxsJAX_SRCS = external/AxsJAX.js
AXSJAX_COMMON_AxsJAX_FILES = $(AXSJAX_COMMON_AxsJAX_DEPS) $(AXSJAX_COMMON_AxsJAX_SRCS)

AXSJAX_COMMON_PowerKey_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(AXSJAX_COMMON_AxsJAX_FILES))
AXSJAX_COMMON_PowerKey_SRCS = external/PowerKey.js
AXSJAX_COMMON_PowerKey_FILES = $(AXSJAX_COMMON_PowerKey_DEPS) $(AXSJAX_COMMON_PowerKey_SRCS)

CHROMEVOX_MESSAGES_spoken_message_DEPS = $(CLOSURE_base_FILES)
CHROMEVOX_MESSAGES_spoken_message_SRCS = chromevox/messages/spoken_message.js
CHROMEVOX_MESSAGES_spoken_message_FILES = $(CHROMEVOX_MESSAGES_spoken_message_DEPS) $(CHROMEVOX_MESSAGES_spoken_message_SRCS)

CHROMEVOX_MESSAGES_spoken_messages_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(CHROMEVOX_MESSAGES_spoken_message_FILES))
CHROMEVOX_MESSAGES_spoken_messages_SRCS = chromevox/messages/spoken_messages.js
CHROMEVOX_MESSAGES_spoken_messages_FILES = $(CHROMEVOX_MESSAGES_spoken_messages_DEPS) $(CHROMEVOX_MESSAGES_spoken_messages_SRCS)

CHROMEVOX_INJECTED_UI_widget_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_MESSAGES_spoken_messages_FILES) $(COMMON_chromevox_FILES) $(HOST_INTERFACE_abstract_earcons_FILES))
CHROMEVOX_INJECTED_UI_widget_SRCS = chromevox/injected/ui/widget.js
CHROMEVOX_INJECTED_UI_widget_FILES = $(CHROMEVOX_INJECTED_UI_widget_DEPS) $(CHROMEVOX_INJECTED_UI_widget_SRCS)

CHROMEVOX_INJECTED_UI_choice_widget_DEPS = $(call uniq, $(AXSJAX_COMMON_PowerKey_FILES) $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(CHROMEVOX_INJECTED_UI_widget_FILES))
CHROMEVOX_INJECTED_UI_choice_widget_SRCS = chromevox/injected/ui/choice_widget.js
CHROMEVOX_INJECTED_UI_choice_widget_FILES = $(CHROMEVOX_INJECTED_UI_choice_widget_DEPS) $(CHROMEVOX_INJECTED_UI_choice_widget_SRCS)

CHROMEVOX_INJECTED_UI_keyboard_help_widget_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES) $(COMMON_command_store_FILES) $(CHROMEVOX_INJECTED_UI_choice_widget_FILES))
CHROMEVOX_INJECTED_UI_keyboard_help_widget_SRCS = chromevox/injected/ui/keyboard_help_widget.js
CHROMEVOX_INJECTED_UI_keyboard_help_widget_FILES = $(CHROMEVOX_INJECTED_UI_keyboard_help_widget_DEPS) $(CHROMEVOX_INJECTED_UI_keyboard_help_widget_SRCS)

CHROMEVOX_INJECTED_UI_node_chooser_widget_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_MESSAGES_spoken_messages_FILES) $(COMMON_chromevox_FILES) $(COMMON_dom_util_FILES) $(CHROMEVOX_INJECTED_UI_choice_widget_FILES))
CHROMEVOX_INJECTED_UI_node_chooser_widget_SRCS = chromevox/injected/ui/node_chooser_widget.js
CHROMEVOX_INJECTED_UI_node_chooser_widget_FILES = $(CHROMEVOX_INJECTED_UI_node_chooser_widget_DEPS) $(CHROMEVOX_INJECTED_UI_node_chooser_widget_SRCS)

COMMON_selection_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_dom_util_FILES) $(COMMON_xpath_util_FILES))
COMMON_selection_util_SRCS = common/selection_util.js
COMMON_selection_util_FILES = $(COMMON_selection_util_DEPS) $(COMMON_selection_util_SRCS)

COMMON_cursor_selection_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_FILES) $(COMMON_selection_util_FILES) $(COMMON_traverse_util_FILES))
COMMON_cursor_selection_SRCS = common/cursor_selection.js
COMMON_cursor_selection_FILES = $(COMMON_cursor_selection_DEPS) $(COMMON_cursor_selection_SRCS)

WALKERS_abstract_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_selection_FILES))
WALKERS_abstract_walker_SRCS = walkers/abstract_walker.js
WALKERS_abstract_walker_FILES = $(WALKERS_abstract_walker_DEPS) $(WALKERS_abstract_walker_SRCS)

WALKERS_abstract_node_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_selection_FILES) $(COMMON_dom_util_FILES) $(WALKERS_abstract_walker_FILES))
WALKERS_abstract_node_walker_SRCS = walkers/abstract_node_walker.js
WALKERS_abstract_node_walker_FILES = $(WALKERS_abstract_node_walker_DEPS) $(WALKERS_abstract_node_walker_SRCS)

WALKERS_bare_object_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(WALKERS_abstract_node_walker_FILES))
WALKERS_bare_object_walker_SRCS = walkers/bare_object_walker.js
WALKERS_bare_object_walker_FILES = $(WALKERS_bare_object_walker_DEPS) $(WALKERS_bare_object_walker_SRCS)

COMMON_earcon_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(COMMON_aria_util_FILES) $(COMMON_dom_util_FILES))
COMMON_earcon_util_SRCS = common/earcon_util.js
COMMON_earcon_util_FILES = $(COMMON_earcon_util_DEPS) $(COMMON_earcon_util_SRCS)

COMMON_nav_description_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(COMMON_chromevox_FILES) $(COMMON_cursor_selection_FILES))
COMMON_nav_description_SRCS = common/nav_description.js
COMMON_nav_description_FILES = $(COMMON_nav_description_DEPS) $(COMMON_nav_description_SRCS)

COMMON_description_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(WALKERS_bare_object_walker_FILES) $(COMMON_dom_util_FILES) $(COMMON_earcon_util_FILES) $(COMMON_nav_description_FILES))
COMMON_description_util_SRCS = common/description_util.js
COMMON_description_util_FILES = $(COMMON_description_util_DEPS) $(COMMON_description_util_SRCS)

COMMON_interframe_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_json_FILES) $(COMMON_dom_util_FILES))
COMMON_interframe_SRCS = common/interframe.js
COMMON_interframe_FILES = $(COMMON_interframe_DEPS) $(COMMON_interframe_SRCS)

COMMON_page_selection_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(COMMON_cursor_selection_FILES) $(COMMON_nav_description_FILES))
COMMON_page_selection_SRCS = common/page_selection.js
COMMON_page_selection_FILES = $(COMMON_page_selection_DEPS) $(COMMON_page_selection_SRCS)

COMMON_walker_decorator_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_json_FILES))
COMMON_walker_decorator_SRCS = common/walker_decorator.js
COMMON_walker_decorator_FILES = $(COMMON_walker_decorator_DEPS) $(COMMON_walker_decorator_SRCS)

CHROMEVOX_INJECTED_active_indicator_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_FILES) $(COMMON_dom_util_FILES))
CHROMEVOX_INJECTED_active_indicator_SRCS = chromevox/injected/active_indicator.js
CHROMEVOX_INJECTED_active_indicator_FILES = $(CHROMEVOX_INJECTED_active_indicator_DEPS) $(CHROMEVOX_INJECTED_active_indicator_SRCS)

CHROMEVOX_INJECTED_navigation_history_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_dom_util_FILES))
CHROMEVOX_INJECTED_navigation_history_SRCS = chromevox/injected/navigation_history.js
CHROMEVOX_INJECTED_navigation_history_FILES = $(CHROMEVOX_INJECTED_navigation_history_DEPS) $(CHROMEVOX_INJECTED_navigation_history_SRCS)

COMMON_traverse_content_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_selection_FILES) $(COMMON_dom_util_FILES) $(COMMON_selection_util_FILES) $(COMMON_traverse_util_FILES))
COMMON_traverse_content_SRCS = common/traverse_content.js
COMMON_traverse_content_FILES = $(COMMON_traverse_content_DEPS) $(COMMON_traverse_content_SRCS)

WALKERS_abstract_selection_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_description_util_FILES) $(COMMON_dom_util_FILES) $(COMMON_traverse_content_FILES) $(WALKERS_abstract_walker_FILES) $(WALKERS_bare_object_walker_FILES))
WALKERS_abstract_selection_walker_SRCS = walkers/abstract_selection_walker.js
WALKERS_abstract_selection_walker_FILES = $(WALKERS_abstract_selection_walker_DEPS) $(WALKERS_abstract_selection_walker_SRCS)

WALKERS_character_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_traverse_content_FILES) $(WALKERS_abstract_selection_walker_FILES))
WALKERS_character_walker_SRCS = walkers/character_walker.js
WALKERS_character_walker_FILES = $(WALKERS_character_walker_DEPS) $(WALKERS_character_walker_SRCS)

COMMON_group_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_aria_util_FILES) $(COMMON_dom_util_FILES))
COMMON_group_util_SRCS = common/group_util.js
COMMON_group_util_FILES = $(COMMON_group_util_DEPS) $(COMMON_group_util_SRCS)

WALKERS_group_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_UI_choice_widget_FILES) $(COMMON_cursor_selection_FILES) $(COMMON_description_util_FILES) $(COMMON_dom_util_FILES) $(COMMON_group_util_FILES) $(WALKERS_abstract_node_walker_FILES))
WALKERS_group_walker_SRCS = walkers/group_walker.js
WALKERS_group_walker_FILES = $(WALKERS_group_walker_DEPS) $(WALKERS_group_walker_SRCS)

WALKERS_object_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_description_util_FILES) $(WALKERS_abstract_node_walker_FILES))
WALKERS_object_walker_SRCS = walkers/object_walker.js
WALKERS_object_walker_FILES = $(WALKERS_object_walker_DEPS) $(WALKERS_object_walker_SRCS)

WALKERS_sentence_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_traverse_content_FILES) $(WALKERS_abstract_selection_walker_FILES))
WALKERS_sentence_walker_SRCS = walkers/sentence_walker.js
WALKERS_sentence_walker_FILES = $(WALKERS_sentence_walker_DEPS) $(WALKERS_sentence_walker_SRCS)

COMMON_dom_predicates_DEPS = $(CLOSURE_base_FILES)
COMMON_dom_predicates_SRCS = common/dom_predicates.js
COMMON_dom_predicates_FILES = $(COMMON_dom_predicates_DEPS) $(COMMON_dom_predicates_SRCS)

COMMON_table_util_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_xpath_util_FILES))
COMMON_table_util_SRCS = common/table_util.js
COMMON_table_util_FILES = $(COMMON_table_util_DEPS) $(COMMON_table_util_SRCS)

COMMON_traverse_table_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_dom_predicates_FILES) $(COMMON_dom_util_FILES) $(COMMON_selection_util_FILES) $(COMMON_table_util_FILES) $(COMMON_traverse_util_FILES))
COMMON_traverse_table_SRCS = common/traverse_table.js
COMMON_traverse_table_FILES = $(COMMON_traverse_table_DEPS) $(COMMON_traverse_table_SRCS)

WALKERS_table_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_description_util_FILES) $(COMMON_dom_util_FILES) $(COMMON_nav_description_FILES) $(COMMON_traverse_table_FILES) $(WALKERS_abstract_walker_FILES))
WALKERS_table_walker_SRCS = walkers/table_walker.js
WALKERS_table_walker_FILES = $(WALKERS_table_walker_DEPS) $(WALKERS_table_walker_SRCS)

COMMON_css_dimension_DEPS = $(CLOSURE_base_FILES)
COMMON_css_dimension_SRCS = common/css_dimension.js
COMMON_css_dimension_FILES = $(COMMON_css_dimension_DEPS) $(COMMON_css_dimension_SRCS)

WALKERS_visual_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES) $(COMMON_css_dimension_FILES) $(COMMON_dom_util_FILES) $(WALKERS_abstract_node_walker_FILES) $(WALKERS_group_walker_FILES))
WALKERS_visual_walker_SRCS = walkers/visual_walker.js
WALKERS_visual_walker_FILES = $(WALKERS_visual_walker_DEPS) $(WALKERS_visual_walker_SRCS)

WALKERS_word_walker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_traverse_content_FILES) $(WALKERS_abstract_selection_walker_FILES))
WALKERS_word_walker_SRCS = walkers/word_walker.js
WALKERS_word_walker_FILES = $(WALKERS_word_walker_DEPS) $(WALKERS_word_walker_SRCS)

CHROMEVOX_INJECTED_navigation_shifter_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_walker_decorator_FILES) $(WALKERS_character_walker_FILES) $(WALKERS_group_walker_FILES) $(WALKERS_object_walker_FILES) $(WALKERS_sentence_walker_FILES) $(WALKERS_table_walker_FILES) $(WALKERS_visual_walker_FILES) $(WALKERS_word_walker_FILES))
CHROMEVOX_INJECTED_navigation_shifter_SRCS = chromevox/injected/navigation_shifter.js
CHROMEVOX_INJECTED_navigation_shifter_FILES = $(CHROMEVOX_INJECTED_navigation_shifter_DEPS) $(CHROMEVOX_INJECTED_navigation_shifter_SRCS)

CHROMEVOX_INJECTED_navigation_speaker_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_nav_description_FILES))
CHROMEVOX_INJECTED_navigation_speaker_SRCS = chromevox/injected/navigation_speaker.js
CHROMEVOX_INJECTED_navigation_speaker_FILES = $(CHROMEVOX_INJECTED_navigation_speaker_DEPS) $(CHROMEVOX_INJECTED_navigation_speaker_SRCS)

CHROMEVOX_INJECTED_navigation_manager_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_UI_widget_FILES) $(COMMON_chromevox_FILES) $(COMMON_cursor_selection_FILES) $(COMMON_description_util_FILES) $(COMMON_dom_util_FILES) $(COMMON_interframe_FILES) $(COMMON_nav_description_FILES) $(COMMON_page_selection_FILES) $(COMMON_selection_util_FILES) $(COMMON_walker_decorator_FILES) $(CHROMEVOX_INJECTED_active_indicator_FILES) $(CHROMEVOX_INJECTED_event_suspender_FILES) $(CHROMEVOX_INJECTED_navigation_history_FILES) $(CHROMEVOX_INJECTED_navigation_shifter_FILES) $(CHROMEVOX_INJECTED_navigation_speaker_FILES))
CHROMEVOX_INJECTED_navigation_manager_SRCS = chromevox/injected/navigation_manager.js
CHROMEVOX_INJECTED_navigation_manager_FILES = $(CHROMEVOX_INJECTED_navigation_manager_DEPS) $(CHROMEVOX_INJECTED_navigation_manager_SRCS)

CHROMEVOX_INJECTED_UI_search_widget_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_api_implementation_FILES) $(CHROMEVOX_INJECTED_navigation_manager_FILES) $(COMMON_chromevox_FILES) $(COMMON_cursor_FILES) $(COMMON_selection_util_FILES) $(COMMON_traverse_util_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(CHROMEVOX_INJECTED_UI_widget_FILES))
CHROMEVOX_INJECTED_UI_search_widget_SRCS = chromevox/injected/ui/search_widget.js
CHROMEVOX_INJECTED_UI_search_widget_FILES = $(CHROMEVOX_INJECTED_UI_search_widget_DEPS) $(CHROMEVOX_INJECTED_UI_search_widget_SRCS)

COMMON_css_space_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_active_indicator_FILES) $(CHROMEVOX_MESSAGES_spoken_messages_FILES) $(COMMON_chromevox_FILES) $(COMMON_css_dimension_FILES) $(COMMON_description_util_FILES) $(COMMON_dom_util_FILES) $(COMMON_group_util_FILES))
COMMON_css_space_SRCS = common/css_space.js
COMMON_css_space_FILES = $(COMMON_css_space_DEPS) $(COMMON_css_space_SRCS)

HOST_TESTING_tts_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_dom_util_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(HOST_INTERFACE_host_factory_FILES))
HOST_TESTING_tts_SRCS = host/testing/tts.js
HOST_TESTING_tts_FILES = $(HOST_TESTING_tts_DEPS) $(HOST_TESTING_tts_SRCS)

CHROMEVOX_INJECTED_runner_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_UI_choice_widget_FILES) $(COMMON_composite_tts_FILES) $(HOST_TESTING_tts_FILES) $(CHROMEVOX_INJECTED_history_FILES) $(CHROMEVOX_INJECTED_node_breadcrumb_FILES))
CHROMEVOX_INJECTED_runner_SRCS = chromevox/injected/runner.js
CHROMEVOX_INJECTED_runner_FILES = $(CHROMEVOX_INJECTED_runner_DEPS) $(CHROMEVOX_INJECTED_runner_SRCS)

CHROMEVOX_INJECTED_user_commands_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_UI_keyboard_help_widget_FILES) $(CHROMEVOX_INJECTED_UI_node_chooser_widget_FILES) $(CHROMEVOX_INJECTED_UI_search_widget_FILES) $(COMMON_chromevox_FILES) $(COMMON_css_space_FILES) $(COMMON_dom_predicates_FILES) $(COMMON_dom_util_FILES) $(CHROMEVOX_INJECTED_console_tts_FILES) $(CHROMEVOX_INJECTED_runner_FILES))
CHROMEVOX_INJECTED_user_commands_SRCS = chromevox/injected/user_commands.js
CHROMEVOX_INJECTED_user_commands_FILES = $(CHROMEVOX_INJECTED_user_commands_DEPS) $(CHROMEVOX_INJECTED_user_commands_SRCS)

CHROMEVOX_INJECTED_keyboard_handler_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_UI_keyboard_help_widget_FILES) $(COMMON_chromevox_FILES) $(COMMON_key_util_FILES) $(CHROMEVOX_INJECTED_history_FILES) $(CHROMEVOX_INJECTED_user_commands_FILES))
CHROMEVOX_INJECTED_keyboard_handler_SRCS = chromevox/injected/keyboard_handler.js
CHROMEVOX_INJECTED_keyboard_handler_FILES = $(CHROMEVOX_INJECTED_keyboard_handler_DEPS) $(CHROMEVOX_INJECTED_keyboard_handler_SRCS)

CHROMEVOX_INJECTED_live_regions_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_aria_util_FILES) $(COMMON_chromevox_FILES) $(COMMON_description_util_FILES) $(COMMON_dom_util_FILES) $(COMMON_nav_description_FILES))
CHROMEVOX_INJECTED_live_regions_SRCS = chromevox/injected/live_regions.js
CHROMEVOX_INJECTED_live_regions_FILES = $(CHROMEVOX_INJECTED_live_regions_DEPS) $(CHROMEVOX_INJECTED_live_regions_SRCS)

CHROMEVOX_INJECTED_macro_writer_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_user_commands_FILES))
CHROMEVOX_INJECTED_macro_writer_SRCS = chromevox/injected/macro_writer.js
CHROMEVOX_INJECTED_macro_writer_FILES = $(CHROMEVOX_INJECTED_macro_writer_DEPS) $(CHROMEVOX_INJECTED_macro_writer_SRCS)

CHROMEVOX_INJECTED_event_watcher_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_aria_util_FILES) $(COMMON_chromevox_FILES) $(COMMON_dom_util_FILES) $(COMMON_editable_text_FILES) $(CHROMEVOX_INJECTED_api_implementation_FILES) $(CHROMEVOX_INJECTED_event_suspender_FILES) $(CHROMEVOX_INJECTED_history_FILES) $(CHROMEVOX_INJECTED_keyboard_handler_FILES) $(CHROMEVOX_INJECTED_live_regions_FILES) $(CHROMEVOX_INJECTED_macro_writer_FILES) $(CHROMEVOX_INJECTED_user_commands_FILES))
CHROMEVOX_INJECTED_event_watcher_SRCS = chromevox/injected/event_watcher.js
CHROMEVOX_INJECTED_event_watcher_FILES = $(CHROMEVOX_INJECTED_event_watcher_DEPS) $(CHROMEVOX_INJECTED_event_watcher_SRCS)

CHROMEVOX_INJECTED_pdf_processor_DEPS = $(CLOSURE_base_FILES)
CHROMEVOX_INJECTED_pdf_processor_SRCS = chromevox/injected/pdf_processor.js
CHROMEVOX_INJECTED_pdf_processor_FILES = $(CHROMEVOX_INJECTED_pdf_processor_DEPS) $(CHROMEVOX_INJECTED_pdf_processor_SRCS)

HOST_CHROME_host_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_api_implementation_FILES) $(CHROMEVOX_INJECTED_event_watcher_FILES) $(CHROMEVOX_INJECTED_keyboard_handler_FILES) $(CHROMEVOX_INJECTED_pdf_processor_FILES) $(COMMON_chromevox_FILES) $(HOST_INTERFACE_abstract_host_FILES) $(HOST_INTERFACE_host_factory_FILES) $(HOST_CHROME_extension_bridge_FILES))
HOST_CHROME_host_SRCS = host/chrome/host.js
HOST_CHROME_host_FILES = $(HOST_CHROME_host_DEPS) $(HOST_CHROME_host_SRCS)

HOST_CHROME_tts_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(HOST_INTERFACE_host_factory_FILES))
HOST_CHROME_tts_SRCS = host/chrome/tts.js
HOST_CHROME_tts_FILES = $(HOST_CHROME_tts_DEPS) $(HOST_CHROME_tts_SRCS)

CHROMEVOX_BACKGROUND_prefs_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_BACKGROUND_KEYMAPS_key_map_FILES) $(COMMON_chromevox_FILES) $(COMMON_key_util_FILES) $(HOST_CHROME_extension_bridge_FILES))
CHROMEVOX_BACKGROUND_prefs_SRCS = chromevox/background/prefs.js
CHROMEVOX_BACKGROUND_prefs_FILES = $(CHROMEVOX_BACKGROUND_prefs_DEPS) $(CHROMEVOX_BACKGROUND_prefs_SRCS)

CHROMEVOX_BACKGROUND_options_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_BACKGROUND_KEYMAPS_key_map_FILES) $(COMMON_chromevox_FILES) $(COMMON_command_store_FILES) $(HOST_CHROME_earcons_FILES) $(HOST_CHROME_extension_bridge_FILES) $(HOST_CHROME_host_FILES) $(HOST_CHROME_msgs_FILES) $(HOST_CHROME_tts_FILES) $(HOST_INTERFACE_host_factory_FILES) $(CHROMEVOX_BACKGROUND_prefs_FILES))
CHROMEVOX_BACKGROUND_options_SRCS = chromevox/background/options.js
CHROMEVOX_BACKGROUND_options_FILES = $(CHROMEVOX_BACKGROUND_options_DEPS) $(CHROMEVOX_BACKGROUND_options_SRCS)

CHROMEVOX_BACKGROUND_background_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_console_tts_FILES) $(COMMON_chromevox_FILES) $(COMMON_composite_tts_FILES) $(COMMON_editable_text_FILES) $(HOST_CHROME_earcons_background_FILES) $(HOST_CHROME_extension_bridge_FILES) $(HOST_CHROME_msgs_FILES) $(HOST_CHROME_tts_background_FILES) $(HOST_INTERFACE_host_factory_FILES) $(CHROMEVOX_BACKGROUND_accessibility_api_handler_FILES) $(CHROMEVOX_BACKGROUND_injected_script_loader_FILES) $(CHROMEVOX_BACKGROUND_options_FILES) $(CHROMEVOX_BACKGROUND_prefs_FILES))
CHROMEVOX_BACKGROUND_background_SRCS = chromevox/background/background.js
CHROMEVOX_BACKGROUND_background_FILES = $(CHROMEVOX_BACKGROUND_background_DEPS) $(CHROMEVOX_BACKGROUND_background_SRCS)

CHROMEVOX_BACKGROUND_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_CHROME_msgs_FILES) $(CHROMEVOX_BACKGROUND_background_FILES))
CHROMEVOX_BACKGROUND_loader_SRCS = chromevox/background/loader.js
CHROMEVOX_BACKGROUND_loader_FILES = $(CHROMEVOX_BACKGROUND_loader_DEPS) $(CHROMEVOX_BACKGROUND_loader_SRCS)

chromeVoxChromeBackgroundScript_DEPS = $(CHROMEVOX_BACKGROUND_loader_FILES)
chromeVoxChromeBackgroundScript.js_FILES = chromeVoxChromeBackgroundScript.js
chromeVoxChromeBackgroundScript.js: $(chromeVoxChromeBackgroundScript_DEPS)
	@echo Building Javascript binary chromeVoxChromeBackgroundScript.js
	@$(CLOSURE_COMPILER) --js $(chromeVoxChromeBackgroundScript_DEPS) --js_output_file chromeVoxChromeBackgroundScript.js


CHROMEVOX_BACKGROUND_options_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_BACKGROUND_options_FILES))
CHROMEVOX_BACKGROUND_options_loader_SRCS = chromevox/background/options_loader.js
CHROMEVOX_BACKGROUND_options_loader_FILES = $(CHROMEVOX_BACKGROUND_options_loader_DEPS) $(CHROMEVOX_BACKGROUND_options_loader_SRCS)

chromeVoxChromeOptionsScript_DEPS = $(CHROMEVOX_BACKGROUND_options_loader_FILES)
chromeVoxChromeOptionsScript.js_FILES = chromeVoxChromeOptionsScript.js
chromeVoxChromeOptionsScript.js: $(chromeVoxChromeOptionsScript_DEPS)
	@echo Building Javascript binary chromeVoxChromeOptionsScript.js
	@$(CLOSURE_COMPILER) --js $(chromeVoxChromeOptionsScript_DEPS) --js_output_file chromeVoxChromeOptionsScript.js


CHROMEVOX_INJECTED_UI_filtering_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_navigation_manager_FILES) $(CHROMEVOX_MESSAGES_spoken_messages_FILES) $(COMMON_dom_util_FILES) $(CHROMEVOX_INJECTED_UI_widget_FILES))
CHROMEVOX_INJECTED_UI_filtering_SRCS = chromevox/injected/ui/filtering.js
CHROMEVOX_INJECTED_UI_filtering_FILES = $(CHROMEVOX_INJECTED_UI_filtering_DEPS) $(CHROMEVOX_INJECTED_UI_filtering_SRCS)

HOST_INTERFACE_abstract_lens_DEPS = $(CLOSURE_base_FILES)
HOST_INTERFACE_abstract_lens_SRCS = host/interface/abstract_lens.js
HOST_INTERFACE_abstract_lens_FILES = $(HOST_INTERFACE_abstract_lens_DEPS) $(HOST_INTERFACE_abstract_lens_SRCS)

COMMON_lens_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_lens_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(HOST_INTERFACE_tts_interface_FILES) $(COMMON_selection_util_FILES) $(COMMON_traverse_util_FILES))
COMMON_lens_SRCS = common/lens.js
COMMON_lens_FILES = $(COMMON_lens_DEPS) $(COMMON_lens_SRCS)

CHROMEVOX_INJECTED_serializer_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_chromevox_FILES) $(CHROMEVOX_INJECTED_event_watcher_FILES))
CHROMEVOX_INJECTED_serializer_SRCS = chromevox/injected/serializer.js
CHROMEVOX_INJECTED_serializer_FILES = $(CHROMEVOX_INJECTED_serializer_DEPS) $(CHROMEVOX_INJECTED_serializer_SRCS)

CHROMEVOX_INJECTED_tts_history_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_tts_interface_FILES))
CHROMEVOX_INJECTED_tts_history_SRCS = chromevox/injected/tts_history.js
CHROMEVOX_INJECTED_tts_history_FILES = $(CHROMEVOX_INJECTED_tts_history_DEPS) $(CHROMEVOX_INJECTED_tts_history_SRCS)

CHROMEVOX_INJECTED_init_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_UI_filtering_FILES) $(CHROMEVOX_MESSAGES_spoken_messages_FILES) $(COMMON_chromevox_FILES) $(COMMON_chromevox_json_FILES) $(COMMON_composite_tts_FILES) $(COMMON_description_util_FILES) $(COMMON_dom_util_FILES) $(COMMON_lens_FILES) $(HOST_INTERFACE_host_factory_FILES) $(CHROMEVOX_INJECTED_api_implementation_FILES) $(CHROMEVOX_INJECTED_console_tts_FILES) $(CHROMEVOX_INJECTED_event_watcher_FILES) $(CHROMEVOX_INJECTED_keyboard_handler_FILES) $(CHROMEVOX_INJECTED_live_regions_FILES) $(CHROMEVOX_INJECTED_navigation_manager_FILES) $(CHROMEVOX_INJECTED_serializer_FILES) $(CHROMEVOX_INJECTED_tts_history_FILES))
CHROMEVOX_INJECTED_init_SRCS = chromevox/injected/init.js
CHROMEVOX_INJECTED_init_FILES = $(CHROMEVOX_INJECTED_init_DEPS) $(CHROMEVOX_INJECTED_init_SRCS)

CHROMEVOX_INJECTED_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_CHROME_earcons_FILES) $(HOST_CHROME_host_FILES) $(HOST_CHROME_msgs_FILES) $(HOST_CHROME_tts_FILES) $(CHROMEVOX_INJECTED_init_FILES))
CHROMEVOX_INJECTED_loader_SRCS = chromevox/injected/loader.js
CHROMEVOX_INJECTED_loader_FILES = $(CHROMEVOX_INJECTED_loader_DEPS) $(CHROMEVOX_INJECTED_loader_SRCS)

chromeVoxChromePageScript_DEPS = $(CHROMEVOX_INJECTED_loader_FILES)
chromeVoxChromePageScript.js_FILES = chromeVoxChromePageScript.js
chromeVoxChromePageScript.js: $(chromeVoxChromePageScript_DEPS)
	@echo Building Javascript binary chromeVoxChromePageScript.js
	@$(CLOSURE_COMPILER) --js $(chromeVoxChromePageScript_DEPS) --js_output_file chromeVoxChromePageScript.js


CHROMEVOX_BACKGROUND_kbexplorer_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_key_util_FILES))
CHROMEVOX_BACKGROUND_kbexplorer_SRCS = chromevox/background/kbexplorer.js
CHROMEVOX_BACKGROUND_kbexplorer_FILES = $(CHROMEVOX_BACKGROUND_kbexplorer_DEPS) $(CHROMEVOX_BACKGROUND_kbexplorer_SRCS)

CHROMEVOX_BACKGROUND_kbexplorer_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_BACKGROUND_kbexplorer_FILES))
CHROMEVOX_BACKGROUND_kbexplorer_loader_SRCS = chromevox/background/kbexplorer_loader.js
CHROMEVOX_BACKGROUND_kbexplorer_loader_FILES = $(CHROMEVOX_BACKGROUND_kbexplorer_loader_DEPS) $(CHROMEVOX_BACKGROUND_kbexplorer_loader_SRCS)

chromeVoxKbExplorerScript_DEPS = $(CHROMEVOX_BACKGROUND_kbexplorer_loader_FILES)
chromeVoxKbExplorerScript.js_FILES = chromeVoxKbExplorerScript.js
chromeVoxKbExplorerScript.js: $(chromeVoxKbExplorerScript_DEPS)
	@echo Building Javascript binary chromeVoxKbExplorerScript.js
	@$(CLOSURE_COMPILER) --js $(chromeVoxKbExplorerScript_DEPS) --js_output_file chromeVoxKbExplorerScript.js


CHROMEVOX_INJECTED_runner_interface_DEPS = $(CLOSURE_base_FILES)
CHROMEVOX_INJECTED_runner_interface_SRCS = chromevox/injected/runner_interface.js
CHROMEVOX_INJECTED_runner_interface_FILES = $(CHROMEVOX_INJECTED_runner_interface_DEPS) $(CHROMEVOX_INJECTED_runner_interface_SRCS)

CHROMEVOX_TESTING_abstract_test_case_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_runner_interface_FILES))
CHROMEVOX_TESTING_abstract_test_case_SRCS = chromevox/testing/abstract_test_case.js
CHROMEVOX_TESTING_abstract_test_case_FILES = $(CHROMEVOX_TESTING_abstract_test_case_DEPS) $(CHROMEVOX_TESTING_abstract_test_case_SRCS)

HOST_TESTING_host_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_host_FILES) $(HOST_INTERFACE_host_factory_FILES))
HOST_TESTING_host_SRCS = host/testing/host.js
HOST_TESTING_host_FILES = $(HOST_TESTING_host_DEPS) $(HOST_TESTING_host_SRCS)

CHROMEVOX_MESSAGES_messages_en.json_FILES = chromevox/messages/_locales/en/messages.json
HOST_TESTING_test_messages_SRCS = $(call uniq, host/testing/test_messages.jsfragment $(CHROMEVOX_MESSAGES_messages_en.json_FILES))
HOST_TESTING_test_messages_FILES = host/testing/test_messages.js
host/testing/test_messages.js: $(HOST_TESTING_test_messages_SRCS)
	@echo Generating file host/testing/test_messages.js
	@mkdir -p $(dir host/testing/test_messages.js)
	@cat $(HOST_TESTING_test_messages_SRCS) >$(HOST_TESTING_test_messages_FILES)


HOST_TESTING_test_messages.js_FILES = $(HOST_TESTING_test_messages_FILES)
HOST_TESTING_test_messages_lib_DEPS = $(CLOSURE_base_FILES)
HOST_TESTING_test_messages_lib_SRCS = $(HOST_TESTING_test_messages.js_FILES)
HOST_TESTING_test_messages_lib_FILES = $(HOST_TESTING_test_messages_lib_DEPS) $(HOST_TESTING_test_messages_lib_SRCS)

HOST_TESTING_msgs_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_msgs_FILES) $(HOST_INTERFACE_host_factory_FILES) $(HOST_TESTING_test_messages_lib_FILES))
HOST_TESTING_msgs_SRCS = host/testing/msgs.js
HOST_TESTING_msgs_FILES = $(HOST_TESTING_msgs_DEPS) $(HOST_TESTING_msgs_SRCS)

CHROMEVOX_TESTING_tester_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_event_watcher_FILES) $(CHROMEVOX_INJECTED_live_regions_FILES) $(CHROMEVOX_INJECTED_navigation_manager_FILES) $(CHROMEVOX_INJECTED_navigation_shifter_FILES) $(CHROMEVOX_INJECTED_user_commands_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(HOST_TESTING_host_FILES) $(HOST_TESTING_msgs_FILES) $(HOST_TESTING_tts_FILES))
CHROMEVOX_TESTING_tester_SRCS = chromevox/testing/tester.js
CHROMEVOX_TESTING_tester_FILES = $(CHROMEVOX_TESTING_tester_DEPS) $(CHROMEVOX_TESTING_tester_SRCS)

CHROMEVOX_INJECTED_event_watcher_test_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_TESTING_abstract_test_case_FILES) $(CHROMEVOX_TESTING_tester_FILES))
CHROMEVOX_INJECTED_event_watcher_test_SRCS = chromevox/injected/event_watcher_test.js
CHROMEVOX_INJECTED_event_watcher_test_FILES = $(CHROMEVOX_INJECTED_event_watcher_test_DEPS) $(CHROMEVOX_INJECTED_event_watcher_test_SRCS)

CHROMEVOX_BACKGROUND_tests_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_event_watcher_test_FILES) $(CHROMEVOX_INJECTED_init_FILES) $(CHROMEVOX_INJECTED_runner_FILES) $(COMMON_chromevox_FILES) $(HOST_CHROME_earcons_FILES) $(HOST_CHROME_extension_bridge_FILES) $(HOST_CHROME_host_FILES) $(HOST_CHROME_msgs_FILES) $(HOST_CHROME_tts_FILES) $(HOST_INTERFACE_host_factory_FILES))
CHROMEVOX_BACKGROUND_tests_SRCS = chromevox/background/tests.js
CHROMEVOX_BACKGROUND_tests_FILES = $(CHROMEVOX_BACKGROUND_tests_DEPS) $(CHROMEVOX_BACKGROUND_tests_SRCS)

chromeVoxTestsScript_DEPS = $(CHROMEVOX_BACKGROUND_tests_FILES)
chromeVoxTestsScript.js_FILES = chromeVoxTestsScript.js
chromeVoxTestsScript.js: $(chromeVoxTestsScript_DEPS)
	@echo Building Javascript binary chromeVoxTestsScript.js
	@$(CLOSURE_COMPILER) --js $(chromeVoxTestsScript_DEPS) --js_output_file chromeVoxTestsScript.js


CHROMEVOX_BACKGROUND_EARCONS_ogg_files_FILES = $(wildcard chromevox/background/earcons/*.ogg)
CHROMEVOX_BACKGROUND_EARCONS_ogg_files: $(CHROMEVOX_BACKGROUND_EARCONS_ogg_files_FILES)

CHROMEVOX_BACKGROUND_html_files_FILES = $(wildcard chromevox/background/*.html)
CHROMEVOX_BACKGROUND_html_files: $(CHROMEVOX_BACKGROUND_html_files_FILES)

CHROMEVOX_png_files_FILES = $(wildcard chromevox/*.png)
CHROMEVOX_png_files: $(CHROMEVOX_png_files_FILES)

CHROMEVOX_BACKGROUND_KEYMAPS_json_files_FILES = $(wildcard chromevox/background/keymaps/*.json)
CHROMEVOX_BACKGROUND_KEYMAPS_json_files: $(CHROMEVOX_BACKGROUND_KEYMAPS_json_files_FILES)

chromevox_deploy_fs_out_SRCS = $(call uniq, $(CHROMEVOX_manifest_compiled_manifest/manifest.json_FILES) $(CHROMEVOX_MESSAGES_i18n_messages_filegroup_FILES) $(chromeVoxChromeBackgroundScript.js_FILES) $(chromeVoxChromeOptionsScript.js_FILES) $(chromeVoxChromePageScript.js_FILES) $(chromeVoxKbExplorerScript.js_FILES) $(chromeVoxTestsScript.js_FILES) closure/closure_preinit.js $(CHROMEVOX_BACKGROUND_EARCONS_ogg_files_FILES) chromevox/injected/api.js chromevox/injected/api_util.js $(CHROMEVOX_BACKGROUND_html_files_FILES) $(CHROMEVOX_png_files_FILES) $(CHROMEVOX_BACKGROUND_KEYMAPS_json_files_FILES))
chromevox_deploy_fs_out_FILES = chromevox_deploy_fs_out
chromevox_deploy_fs_out: $(chromevox_deploy_fs_out_SRCS)
	@echo Building Fileset chromevox_deploy_fs_out
	@mkdir -p $(chromevox_deploy_fs_out_FILES)
	@cp $(CHROMEVOX_manifest_compiled_manifest/manifest.json_FILES) chromevox_deploy_fs_out/
	@mkdir -p chromevox_deploy_fs_out/_locales/en
	@cp $(CHROMEVOX_MESSAGES_i18n_messages_filegroup_FILES) chromevox_deploy_fs_out/_locales/en
	@cp $(chromeVoxChromeBackgroundScript.js_FILES) chromevox_deploy_fs_out/
	@cp $(chromeVoxChromeOptionsScript.js_FILES) chromevox_deploy_fs_out/
	@cp $(chromeVoxChromePageScript.js_FILES) chromevox_deploy_fs_out/
	@cp $(chromeVoxKbExplorerScript.js_FILES) chromevox_deploy_fs_out/
	@cp $(chromeVoxTestsScript.js_FILES) chromevox_deploy_fs_out/
	@cp closure/closure_preinit.js chromevox_deploy_fs_out/
	@mkdir -p chromevox_deploy_fs_out/chromevox/background/earcons
	@cp $(CHROMEVOX_BACKGROUND_EARCONS_ogg_files_FILES) chromevox_deploy_fs_out/chromevox/background/earcons
	@mkdir -p chromevox_deploy_fs_out/chromevox/injected
	@cp chromevox/injected/api.js chromevox_deploy_fs_out/chromevox/injected
	@mkdir -p chromevox_deploy_fs_out/chromevox/injected
	@cp chromevox/injected/api_util.js chromevox_deploy_fs_out/chromevox/injected
	@mkdir -p chromevox_deploy_fs_out/chromevox/background
	@cp $(CHROMEVOX_BACKGROUND_html_files_FILES) chromevox_deploy_fs_out/chromevox/background
	@mkdir -p chromevox_deploy_fs_out/chromevox
	@cp $(CHROMEVOX_png_files_FILES) chromevox_deploy_fs_out/chromevox
	@mkdir -p chromevox_deploy_fs_out/chromevox/background/keymaps
	@cp $(CHROMEVOX_BACKGROUND_KEYMAPS_json_files_FILES) chromevox_deploy_fs_out/chromevox/background/keymaps

chromevox_deploy_fs: chromevox_deploy_fs_out
chromevox_deploy_fs_FILES = $(chromevox_deploy_fs_out_FILES)
chromevox_deploy_crx_SRCS = $(call uniq, $(chromevox_deploy_fs_FILES) private_keys/chromevox.pem external/package.sh)
chromevox_deploy_crx_FILES = chromevox_deploy.crx
chromevox_deploy.crx: $(chromevox_deploy_crx_SRCS)
	@echo Generating file chromevox_deploy.crx
	@external/package.sh --key private_keys/chromevox.pem --src $(chromevox_deploy_fs_FILES) --crx $@


CHROMEVOX_manifest_uncompiled_manifest_gen_SRCS = chromevox/manifest_uncompiled.json
CHROMEVOX_manifest_uncompiled_manifest_gen_FILES = chromevox/manifest_uncompiled_manifest/manifest.json
chromevox/manifest_uncompiled_manifest/manifest.json: $(CHROMEVOX_manifest_uncompiled_manifest_gen_SRCS)
	@echo Generating file chromevox/manifest_uncompiled_manifest/manifest.json
	@mkdir -p $(dir chromevox/manifest_uncompiled_manifest/manifest.json)
	@cat $< >$@


CHROMEVOX_manifest_uncompiled_manifest/manifest.json_FILES = $(CHROMEVOX_manifest_uncompiled_manifest_gen_FILES)
chromevox_deploy_uncompiled_fs_out_SRCS = $(call uniq, $(CHROMEVOX_manifest_uncompiled_manifest/manifest.json_FILES) $(CHROMEVOX_MESSAGES_i18n_messages_filegroup_FILES))
chromevox_deploy_uncompiled_fs_out_FILES = chromevox_deploy_uncompiled_fs_out
chromevox_deploy_uncompiled_fs_out: $(chromevox_deploy_uncompiled_fs_out_SRCS)
	@echo Building Fileset chromevox_deploy_uncompiled_fs_out
	@mkdir -p $(chromevox_deploy_uncompiled_fs_out_FILES)
	@cp $(CHROMEVOX_manifest_uncompiled_manifest/manifest.json_FILES) chromevox_deploy_uncompiled_fs_out/
	@mkdir -p chromevox_deploy_uncompiled_fs_out/_locales/en
	@cp $(CHROMEVOX_MESSAGES_i18n_messages_filegroup_FILES) chromevox_deploy_uncompiled_fs_out/_locales/en

chromevox_deploy_uncompiled_fs: chromevox_deploy_uncompiled_fs_out
chromevox_deploy_uncompiled_fs_FILES = $(chromevox_deploy_uncompiled_fs_out_FILES)
chromevox: deps.js chromevox_deploy_uncompiled_fs
	@echo Building unpacked Chrome extension for chromevox
	@cp -a chromevox_deploy_uncompiled_fs_out/* .

HOST_ANDROID_DEV_earcons_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_earcons_FILES) $(HOST_INTERFACE_host_factory_FILES))
HOST_ANDROID_DEV_earcons_SRCS = host/android_dev/earcons.js
HOST_ANDROID_DEV_earcons_FILES = $(HOST_ANDROID_DEV_earcons_DEPS) $(HOST_ANDROID_DEV_earcons_SRCS)

HOST_ANDROID_DEV_androidvox_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_user_commands_FILES) $(COMMON_chromevox_FILES))
HOST_ANDROID_DEV_androidvox_SRCS = host/android_dev/androidvox.js
HOST_ANDROID_DEV_androidvox_FILES = $(HOST_ANDROID_DEV_androidvox_DEPS) $(HOST_ANDROID_DEV_androidvox_SRCS)

HOST_ANDROID_DEV_host_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_api_implementation_FILES) $(CHROMEVOX_INJECTED_event_watcher_FILES) $(CHROMEVOX_INJECTED_keyboard_handler_FILES) $(HOST_INTERFACE_abstract_host_FILES) $(HOST_INTERFACE_host_factory_FILES) $(HOST_ANDROID_DEV_androidvox_FILES))
HOST_ANDROID_DEV_host_SRCS = host/android_dev/host.js
HOST_ANDROID_DEV_host_FILES = $(HOST_ANDROID_DEV_host_DEPS) $(HOST_ANDROID_DEV_host_SRCS)

HOST_ANDROID_DEV_tts_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_INTERFACE_abstract_tts_FILES) $(HOST_INTERFACE_host_factory_FILES))
HOST_ANDROID_DEV_tts_SRCS = host/android_dev/tts.js
HOST_ANDROID_DEV_tts_FILES = $(HOST_ANDROID_DEV_tts_DEPS) $(HOST_ANDROID_DEV_tts_SRCS)

ANDROID_INJECTED_GESTURES_UTILS_math_DEPS = $(CLOSURE_base_FILES)
ANDROID_INJECTED_GESTURES_UTILS_math_SRCS = android/injected/gestures/utils/math.js
ANDROID_INJECTED_GESTURES_UTILS_math_FILES = $(ANDROID_INJECTED_GESTURES_UTILS_math_DEPS) $(ANDROID_INJECTED_GESTURES_UTILS_math_SRCS)

ANDROID_INJECTED_GESTURES_UTILS_event_DEPS = $(CLOSURE_base_FILES)
ANDROID_INJECTED_GESTURES_UTILS_event_SRCS = android/injected/gestures/utils/event.js
ANDROID_INJECTED_GESTURES_UTILS_event_FILES = $(ANDROID_INJECTED_GESTURES_UTILS_event_DEPS) $(ANDROID_INJECTED_GESTURES_UTILS_event_SRCS)

ANDROID_INJECTED_GESTURES_UTILS_event_target_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_FILES))
ANDROID_INJECTED_GESTURES_UTILS_event_target_SRCS = android/injected/gestures/utils/event_target.js
ANDROID_INJECTED_GESTURES_UTILS_event_target_FILES = $(ANDROID_INJECTED_GESTURES_UTILS_event_target_DEPS) $(ANDROID_INJECTED_GESTURES_UTILS_event_target_SRCS)

ANDROID_INJECTED_GESTURES_UTILS_event_translator_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_target_FILES))
ANDROID_INJECTED_GESTURES_UTILS_event_translator_SRCS = android/injected/gestures/utils/event_translator.js
ANDROID_INJECTED_GESTURES_UTILS_event_translator_FILES = $(ANDROID_INJECTED_GESTURES_UTILS_event_translator_DEPS) $(ANDROID_INJECTED_GESTURES_UTILS_event_translator_SRCS)

ANDROID_INJECTED_GESTURES_gesture_event_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_FILES))
ANDROID_INJECTED_GESTURES_gesture_event_SRCS = android/injected/gestures/gesture_event.js
ANDROID_INJECTED_GESTURES_gesture_event_FILES = $(ANDROID_INJECTED_GESTURES_gesture_event_DEPS) $(ANDROID_INJECTED_GESTURES_gesture_event_SRCS)

ANDROID_INJECTED_GESTURES_gesture_state_DEPS = $(CLOSURE_base_FILES)
ANDROID_INJECTED_GESTURES_gesture_state_SRCS = android/injected/gestures/gesture_state.js
ANDROID_INJECTED_GESTURES_gesture_state_FILES = $(ANDROID_INJECTED_GESTURES_gesture_state_DEPS) $(ANDROID_INJECTED_GESTURES_gesture_state_SRCS)

ANDROID_INJECTED_GESTURES_drag_state_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_gesture_event_FILES) $(ANDROID_INJECTED_GESTURES_gesture_state_FILES))
ANDROID_INJECTED_GESTURES_drag_state_SRCS = android/injected/gestures/drag_state.js
ANDROID_INJECTED_GESTURES_drag_state_FILES = $(ANDROID_INJECTED_GESTURES_drag_state_DEPS) $(ANDROID_INJECTED_GESTURES_drag_state_SRCS)

ANDROID_INJECTED_androidvox_constants_DEPS = $(CLOSURE_base_FILES)
ANDROID_INJECTED_androidvox_constants_SRCS = android/injected/androidvox_constants.js
ANDROID_INJECTED_androidvox_constants_FILES = $(ANDROID_INJECTED_androidvox_constants_DEPS) $(ANDROID_INJECTED_androidvox_constants_SRCS)

ANDROID_INJECTED_GESTURES_gesture_touch_event_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_math_FILES) $(ANDROID_INJECTED_androidvox_constants_FILES) $(ANDROID_INJECTED_GESTURES_gesture_event_FILES))
ANDROID_INJECTED_GESTURES_gesture_touch_event_SRCS = android/injected/gestures/gesture_touch_event.js
ANDROID_INJECTED_GESTURES_gesture_touch_event_FILES = $(ANDROID_INJECTED_GESTURES_gesture_touch_event_DEPS) $(ANDROID_INJECTED_GESTURES_gesture_touch_event_SRCS)

ANDROID_INJECTED_GESTURES_swipe_state_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_gesture_event_FILES) $(ANDROID_INJECTED_GESTURES_gesture_state_FILES))
ANDROID_INJECTED_GESTURES_swipe_state_SRCS = android/injected/gestures/swipe_state.js
ANDROID_INJECTED_GESTURES_swipe_state_FILES = $(ANDROID_INJECTED_GESTURES_swipe_state_DEPS) $(ANDROID_INJECTED_GESTURES_swipe_state_SRCS)

ANDROID_INJECTED_GESTURES_swipe_turn_state_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_gesture_event_FILES) $(ANDROID_INJECTED_GESTURES_gesture_state_FILES) $(ANDROID_INJECTED_GESTURES_swipe_state_FILES))
ANDROID_INJECTED_GESTURES_swipe_turn_state_SRCS = android/injected/gestures/swipe_turn_state.js
ANDROID_INJECTED_GESTURES_swipe_turn_state_FILES = $(ANDROID_INJECTED_GESTURES_swipe_turn_state_DEPS) $(ANDROID_INJECTED_GESTURES_swipe_turn_state_SRCS)

ANDROID_INJECTED_GESTURES_tap_state_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_gesture_event_FILES) $(ANDROID_INJECTED_GESTURES_gesture_state_FILES))
ANDROID_INJECTED_GESTURES_tap_state_SRCS = android/injected/gestures/tap_state.js
ANDROID_INJECTED_GESTURES_tap_state_FILES = $(ANDROID_INJECTED_GESTURES_tap_state_DEPS) $(ANDROID_INJECTED_GESTURES_tap_state_SRCS)

ANDROID_INJECTED_GESTURES_gesture_detector_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_translator_FILES) $(ANDROID_INJECTED_GESTURES_drag_state_FILES) $(ANDROID_INJECTED_GESTURES_gesture_state_FILES) $(ANDROID_INJECTED_GESTURES_gesture_touch_event_FILES) $(ANDROID_INJECTED_GESTURES_swipe_state_FILES) $(ANDROID_INJECTED_GESTURES_swipe_turn_state_FILES) $(ANDROID_INJECTED_GESTURES_tap_state_FILES))
ANDROID_INJECTED_GESTURES_gesture_detector_SRCS = android/injected/gestures/gesture_detector.js
ANDROID_INJECTED_GESTURES_gesture_detector_FILES = $(ANDROID_INJECTED_GESTURES_gesture_detector_DEPS) $(ANDROID_INJECTED_GESTURES_gesture_detector_SRCS)

ANDROID_INJECTED_NAVIGATION_gesture_navigation_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_math_FILES) $(ANDROID_INJECTED_GESTURES_gesture_detector_FILES) $(ANDROID_INJECTED_GESTURES_gesture_event_FILES))
ANDROID_INJECTED_NAVIGATION_gesture_navigation_SRCS = android/injected/navigation/gesture_navigation.js
ANDROID_INJECTED_NAVIGATION_gesture_navigation_FILES = $(ANDROID_INJECTED_NAVIGATION_gesture_navigation_DEPS) $(ANDROID_INJECTED_NAVIGATION_gesture_navigation_SRCS)

ANDROID_INJECTED_NAVIGATION_dom_navigator_DEPS = $(CLOSURE_base_FILES)
ANDROID_INJECTED_NAVIGATION_dom_navigator_SRCS = android/injected/navigation/dom_navigator.js
ANDROID_INJECTED_NAVIGATION_dom_navigator_FILES = $(ANDROID_INJECTED_NAVIGATION_dom_navigator_DEPS) $(ANDROID_INJECTED_NAVIGATION_dom_navigator_SRCS)

ANDROID_INJECTED_cvox_dom_navigator_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_NAVIGATION_dom_navigator_FILES) $(CHROMEVOX_INJECTED_event_watcher_FILES) $(CHROMEVOX_INJECTED_user_commands_FILES) $(HOST_ANDROID_DEV_tts_FILES) $(HOST_INTERFACE_abstract_tts_FILES))
ANDROID_INJECTED_cvox_dom_navigator_SRCS = android/injected/cvox_dom_navigator.js
ANDROID_INJECTED_cvox_dom_navigator_FILES = $(ANDROID_INJECTED_cvox_dom_navigator_DEPS) $(ANDROID_INJECTED_cvox_dom_navigator_SRCS)

ANDROID_INJECTED_GESTURES_input_translator_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_translator_FILES) $(ANDROID_INJECTED_GESTURES_gesture_touch_event_FILES))
ANDROID_INJECTED_GESTURES_input_translator_SRCS = android/injected/gestures/input_translator.js
ANDROID_INJECTED_GESTURES_input_translator_FILES = $(ANDROID_INJECTED_GESTURES_input_translator_DEPS) $(ANDROID_INJECTED_GESTURES_input_translator_SRCS)

ANDROID_INJECTED_touch_explore_input_translator_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_GESTURES_UTILS_event_FILES) $(ANDROID_INJECTED_GESTURES_gesture_touch_event_FILES) $(ANDROID_INJECTED_GESTURES_input_translator_FILES))
ANDROID_INJECTED_touch_explore_input_translator_SRCS = android/injected/touch_explore_input_translator.js
ANDROID_INJECTED_touch_explore_input_translator_FILES = $(ANDROID_INJECTED_touch_explore_input_translator_DEPS) $(ANDROID_INJECTED_touch_explore_input_translator_SRCS)

ANDROID_INJECTED_androidvox_navigation_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_NAVIGATION_gesture_navigation_FILES) $(ANDROID_INJECTED_androidvox_constants_FILES) $(ANDROID_INJECTED_cvox_dom_navigator_FILES) $(ANDROID_INJECTED_touch_explore_input_translator_FILES))
ANDROID_INJECTED_androidvox_navigation_SRCS = android/injected/androidvox_navigation.js
ANDROID_INJECTED_androidvox_navigation_FILES = $(ANDROID_INJECTED_androidvox_navigation_DEPS) $(ANDROID_INJECTED_androidvox_navigation_SRCS)

ANDROID_INJECTED_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_init_FILES) $(HOST_ANDROID_DEV_earcons_FILES) $(HOST_ANDROID_DEV_host_FILES) $(HOST_ANDROID_DEV_tts_FILES) $(HOST_TESTING_msgs_FILES) $(ANDROID_INJECTED_androidvox_navigation_FILES))
ANDROID_INJECTED_loader_SRCS = android/injected/loader.js
ANDROID_INJECTED_loader_FILES = $(ANDROID_INJECTED_loader_DEPS) $(ANDROID_INJECTED_loader_SRCS)

androidVoxDev_DEPS = $(ANDROID_INJECTED_loader_FILES)
androidVoxDev.js_FILES = androidVoxDev.js
androidVoxDev.js: $(androidVoxDev_DEPS)
	@echo Building Javascript binary androidVoxDev.js
	@$(CLOSURE_COMPILER) --js $(androidVoxDev_DEPS) --js_output_file androidVoxDev.js


HOST_CLANK_host_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMEVOX_INJECTED_api_implementation_FILES) $(CHROMEVOX_INJECTED_event_watcher_FILES) $(CHROMEVOX_INJECTED_keyboard_handler_FILES) $(HOST_ANDROID_DEV_androidvox_FILES) $(HOST_ANDROID_DEV_host_FILES) $(HOST_INTERFACE_host_factory_FILES))
HOST_CLANK_host_SRCS = host/clank/host.js
HOST_CLANK_host_FILES = $(HOST_CLANK_host_DEPS) $(HOST_CLANK_host_SRCS)

CLANK_INJECTED_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ANDROID_INJECTED_androidvox_navigation_FILES) $(CHROMEVOX_INJECTED_init_FILES) $(HOST_ANDROID_DEV_earcons_FILES) $(HOST_ANDROID_DEV_tts_FILES) $(HOST_CLANK_host_FILES) $(HOST_TESTING_msgs_FILES))
CLANK_INJECTED_loader_SRCS = clank/injected/loader.js
CLANK_INJECTED_loader_FILES = $(CLANK_INJECTED_loader_DEPS) $(CLANK_INJECTED_loader_SRCS)

clankVoxDev_DEPS = $(CLANK_INJECTED_loader_FILES)
clankVoxDev.js_FILES = clankVoxDev.js
clankVoxDev.js: $(clankVoxDev_DEPS)
	@echo Building Javascript binary clankVoxDev.js
	@$(CLOSURE_COMPILER) --js $(clankVoxDev_DEPS) --js_output_file clankVoxDev.js


CHROMEVIS_manifestmanifest_gen_SRCS = chromevis/manifest.json
CHROMEVIS_manifestmanifest_gen_FILES = chromevis/manifest_compiled_manifest/manifest.json
chromevis/manifest_compiled_manifest/manifest.json: $(CHROMEVIS_manifestmanifest_gen_SRCS)
	@echo Generating file chromevis/manifest_compiled_manifest/manifest.json
	@mkdir -p $(dir chromevis/manifest_compiled_manifest/manifest.json)
	@cat $< | sed -e 's/loader.js/LOADER.JS/' | grep -vE '^ *"[^ ]*.js"' | sed -e 's/LOADER.JS/binary.js/' >$@


CHROMEVIS_manifest_compiled_manifest/manifest.json_FILES = $(CHROMEVIS_manifestmanifest_gen_FILES)
CHROMEVIS_i18n_messages_DEPS = $(CLOSURE_base_FILES)
CHROMEVIS_i18n_messages_SRCS = chromevis/i18n_messages.js
CHROMEVIS_i18n_messages_FILES = $(CHROMEVIS_i18n_messages_DEPS) $(CHROMEVIS_i18n_messages_SRCS)

CHROMEVIS_i18n_messages_messages_jslib_DEPS = $(call uniq, $(CHROMEVIS_i18n_messages_FILES) $(CHROME_messages_wrapper_FILES))
CHROMEVIS_i18n_messages_messages_jslib_FILES = $(CHROMEVIS_i18n_messages_messages_jslib_DEPS)

CHROMEVIS_i18n_messages_localized__en_DEPS = $(CHROMEVIS_i18n_messages_messages_jslib_FILES)
chromevis/i18n_messages_localized__en.js_FILES = chromevis/i18n_messages_localized__en.js
chromevis/i18n_messages_localized__en.js: $(CHROMEVIS_i18n_messages_localized__en_DEPS)
	@echo Building Javascript binary chromevis/i18n_messages_localized__en.js
	@$(CLOSURE_COMPILER) --js $(CHROMEVIS_i18n_messages_localized__en_DEPS) --js_output_file chromevis/i18n_messages_localized__en.js


CHROMEVIS_i18n_messages_localized__en.js_FILES = chromevis/i18n_messages_localized__en.js
CHROMEVIS_messages_en.json_SRCS = $(CHROMEVIS_i18n_messages_localized__en.js_FILES)
CHROMEVIS_messages_en.json_FILES = chromevis/_locales/en/messages.json
chromevis/_locales/en/messages.json: $(CHROMEVIS_messages_en.json_SRCS)
	@echo Generating file chromevis/_locales/en/messages.json
	@mkdir -p $(dir chromevis/_locales/en/messages.json)
	@$(RHINO) $(CHROMEVIS_messages_en.json_SRCS) > $(CHROMEVIS_messages_en.json_FILES)


CHROMEVIS__locales/en/messages.json_FILES = $(CHROMEVIS_messages_en.json_FILES)
CHROMEVIS_i18n_messages_filegroup_FILES = $(CHROMEVIS__locales/en/messages.json_FILES)
CHROMEVIS_i18n_messages_filegroup: $(CHROMEVIS_i18n_messages_filegroup_FILES)

CHROMEVIS_BACKGROUND_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_CHROME_extension_bridge_FILES))
CHROMEVIS_BACKGROUND_loader_SRCS = chromevis/background/loader.js
CHROMEVIS_BACKGROUND_loader_FILES = $(CHROMEVIS_BACKGROUND_loader_DEPS) $(CHROMEVIS_BACKGROUND_loader_SRCS)

CHROMEVIS_BACKGROUND_background_DEPS = $(CHROMEVIS_BACKGROUND_loader_FILES)
chromevis/background/background.js_FILES = chromevis/background/background.js
chromevis/background/background.js: $(CHROMEVIS_BACKGROUND_background_DEPS)
	@echo Building Javascript binary chromevis/background/background.js
	@$(CLOSURE_COMPILER) --js $(CHROMEVIS_BACKGROUND_background_DEPS) --js_output_file chromevis/background/background.js


CHROMEVIS_BACKGROUND_background.js_FILES = chromevis/background/background.js
CHROMEVIS_BACKGROUND_html_files_FILES = $(call uniq, $(wildcard chromevis/background/*.html) $(wildcard chromevis/background/*.css))
CHROMEVIS_BACKGROUND_html_files: $(CHROMEVIS_BACKGROUND_html_files_FILES)

COMMON_focus_util_DEPS = $(CLOSURE_base_FILES)
COMMON_focus_util_SRCS = common/focus_util.js
COMMON_focus_util_FILES = $(COMMON_focus_util_DEPS) $(COMMON_focus_util_SRCS)

CHROMEVIS_INJECTED_reader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_lens_FILES) $(COMMON_traverse_content_FILES) $(HOST_CHROME_extension_bridge_FILES))
CHROMEVIS_INJECTED_reader_SRCS = chromevis/injected/reader.js
CHROMEVIS_INJECTED_reader_FILES = $(CHROMEVIS_INJECTED_reader_DEPS) $(CHROMEVIS_INJECTED_reader_SRCS)

CHROMEVIS_INJECTED_main_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_focus_util_FILES) $(COMMON_lens_FILES) $(HOST_CHROME_extension_bridge_FILES) $(CHROMEVIS_INJECTED_reader_FILES))
CHROMEVIS_INJECTED_main_SRCS = chromevis/injected/main.js
CHROMEVIS_INJECTED_main_FILES = $(CHROMEVIS_INJECTED_main_DEPS) $(CHROMEVIS_INJECTED_main_SRCS)

CHROMEVIS_INJECTED_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_CHROME_earcons_FILES) $(HOST_CHROME_host_FILES) $(HOST_CHROME_tts_FILES) $(CHROMEVIS_INJECTED_main_FILES))
CHROMEVIS_INJECTED_loader_SRCS = chromevis/injected/loader.js
CHROMEVIS_INJECTED_loader_FILES = $(CHROMEVIS_INJECTED_loader_DEPS) $(CHROMEVIS_INJECTED_loader_SRCS)

CHROMEVIS_INJECTED_binary_DEPS = $(CHROMEVIS_INJECTED_loader_FILES)
chromevis/injected/binary.js_FILES = chromevis/injected/binary.js
chromevis/injected/binary.js: $(CHROMEVIS_INJECTED_binary_DEPS)
	@echo Building Javascript binary chromevis/injected/binary.js
	@$(CLOSURE_COMPILER) --js $(CHROMEVIS_INJECTED_binary_DEPS) --js_output_file chromevis/injected/binary.js


CHROMEVIS_INJECTED_binary.js_FILES = chromevis/injected/binary.js
CHROMEVIS_png_files_FILES = $(wildcard chromevis/*.png)
CHROMEVIS_png_files: $(CHROMEVIS_png_files_FILES)

chromevis_deploy_fs_out_SRCS = $(call uniq, $(CHROMEVIS_manifest_compiled_manifest/manifest.json_FILES) $(CHROMEVIS_i18n_messages_filegroup_FILES) $(CHROMEVIS_BACKGROUND_background.js_FILES) $(CHROMEVIS_BACKGROUND_html_files_FILES) $(CHROMEVIS_INJECTED_binary.js_FILES) $(CHROMEVIS_png_files_FILES) closure/closure_preinit.js external/arrow.gif external/cross.gif external/hs.png external/hv.png external/jscolor.js external/keycode.js)
chromevis_deploy_fs_out_FILES = chromevis_deploy_fs_out
chromevis_deploy_fs_out: $(chromevis_deploy_fs_out_SRCS)
	@echo Building Fileset chromevis_deploy_fs_out
	@mkdir -p $(chromevis_deploy_fs_out_FILES)
	@cp $(CHROMEVIS_manifest_compiled_manifest/manifest.json_FILES) chromevis_deploy_fs_out/
	@mkdir -p chromevis_deploy_fs_out/_locales/en
	@cp $(CHROMEVIS_i18n_messages_filegroup_FILES) chromevis_deploy_fs_out/_locales/en
	@mkdir -p chromevis_deploy_fs_out/chromevis/background
	@cp $(CHROMEVIS_BACKGROUND_background.js_FILES) chromevis_deploy_fs_out/chromevis/background
	@mkdir -p chromevis_deploy_fs_out/chromevis/background
	@cp $(CHROMEVIS_BACKGROUND_html_files_FILES) chromevis_deploy_fs_out/chromevis/background
	@mkdir -p chromevis_deploy_fs_out/chromevis/injected
	@cp $(CHROMEVIS_INJECTED_binary.js_FILES) chromevis_deploy_fs_out/chromevis/injected
	@mkdir -p chromevis_deploy_fs_out/chromevis
	@cp $(CHROMEVIS_png_files_FILES) chromevis_deploy_fs_out/chromevis
	@cp closure/closure_preinit.js chromevis_deploy_fs_out/
	@cp external/arrow.gif chromevis_deploy_fs_out/
	@cp external/cross.gif chromevis_deploy_fs_out/
	@cp external/hs.png chromevis_deploy_fs_out/
	@cp external/hv.png chromevis_deploy_fs_out/
	@cp external/jscolor.js chromevis_deploy_fs_out/
	@cp external/keycode.js chromevis_deploy_fs_out/

chromevis_deploy_fs: chromevis_deploy_fs_out
chromevis_deploy_fs_FILES = $(chromevis_deploy_fs_out_FILES)
chromevis_deploy_crx_SRCS = $(call uniq, $(chromevis_deploy_fs_FILES) private_keys/chromevis.pem external/package.sh)
chromevis_deploy_crx_FILES = chromevis_deploy.crx
chromevis_deploy.crx: $(chromevis_deploy_crx_SRCS)
	@echo Generating file chromevis_deploy.crx
	@external/package.sh --key private_keys/chromevis.pem --src $(chromevis_deploy_fs_FILES) --crx $@


CHROMEVIS_manifest_uncompiled_manifest_gen_SRCS = chromevis/manifest.json
CHROMEVIS_manifest_uncompiled_manifest_gen_FILES = chromevis/manifest_uncompiled_manifest/manifest.json
chromevis/manifest_uncompiled_manifest/manifest.json: $(CHROMEVIS_manifest_uncompiled_manifest_gen_SRCS)
	@echo Generating file chromevis/manifest_uncompiled_manifest/manifest.json
	@mkdir -p $(dir chromevis/manifest_uncompiled_manifest/manifest.json)
	@cat $< >$@


CHROMEVIS_manifest_uncompiled_manifest/manifest.json_FILES = $(CHROMEVIS_manifest_uncompiled_manifest_gen_FILES)
chromevis_deploy_uncompiled_fs_out_SRCS = $(call uniq, $(CHROMEVIS_manifest_uncompiled_manifest/manifest.json_FILES) $(CHROMEVIS_i18n_messages_filegroup_FILES) external/arrow.gif external/cross.gif external/hs.png external/hv.png external/jscolor.js external/keycode.js)
chromevis_deploy_uncompiled_fs_out_FILES = chromevis_deploy_uncompiled_fs_out
chromevis_deploy_uncompiled_fs_out: $(chromevis_deploy_uncompiled_fs_out_SRCS)
	@echo Building Fileset chromevis_deploy_uncompiled_fs_out
	@mkdir -p $(chromevis_deploy_uncompiled_fs_out_FILES)
	@cp $(CHROMEVIS_manifest_uncompiled_manifest/manifest.json_FILES) chromevis_deploy_uncompiled_fs_out/
	@mkdir -p chromevis_deploy_uncompiled_fs_out/_locales/en
	@cp $(CHROMEVIS_i18n_messages_filegroup_FILES) chromevis_deploy_uncompiled_fs_out/_locales/en
	@cp external/arrow.gif chromevis_deploy_uncompiled_fs_out/
	@cp external/cross.gif chromevis_deploy_uncompiled_fs_out/
	@cp external/hs.png chromevis_deploy_uncompiled_fs_out/
	@cp external/hv.png chromevis_deploy_uncompiled_fs_out/
	@cp external/jscolor.js chromevis_deploy_uncompiled_fs_out/
	@cp external/keycode.js chromevis_deploy_uncompiled_fs_out/

chromevis_deploy_uncompiled_fs: chromevis_deploy_uncompiled_fs_out
chromevis_deploy_uncompiled_fs_FILES = $(chromevis_deploy_uncompiled_fs_out_FILES)
chromevis: deps.js chromevis_deploy_uncompiled_fs
	@echo Building unpacked Chrome extension for chromevis
	@cp -a chromevis_deploy_uncompiled_fs_out/* .

CHROMESHADES_manifestmanifest_gen_SRCS = chromeshades/manifest.json
CHROMESHADES_manifestmanifest_gen_FILES = chromeshades/manifest_compiled_manifest/manifest.json
chromeshades/manifest_compiled_manifest/manifest.json: $(CHROMESHADES_manifestmanifest_gen_SRCS)
	@echo Generating file chromeshades/manifest_compiled_manifest/manifest.json
	@mkdir -p $(dir chromeshades/manifest_compiled_manifest/manifest.json)
	@cat $< | sed -e 's/loader.js/LOADER.JS/' | grep -vE '^ *"[^ ]*.js"' | sed -e 's/LOADER.JS/binary.js/' >$@


CHROMESHADES_manifest_compiled_manifest/manifest.json_FILES = $(CHROMESHADES_manifestmanifest_gen_FILES)
CHROMESHADES_INJECTED_base_modifier_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_dom_util_FILES) $(COMMON_interframe_FILES) $(HOST_CHROME_extension_bridge_FILES))
CHROMESHADES_INJECTED_base_modifier_SRCS = chromeshades/injected/base_modifier.js
CHROMESHADES_INJECTED_base_modifier_FILES = $(CHROMESHADES_INJECTED_base_modifier_DEPS) $(CHROMESHADES_INJECTED_base_modifier_SRCS)

CHROMESHADES_INJECTED_shades_modifier_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_xpath_util_FILES))
CHROMESHADES_INJECTED_shades_modifier_SRCS = chromeshades/injected/shades_modifier.js
CHROMESHADES_INJECTED_shades_modifier_FILES = $(CHROMESHADES_INJECTED_shades_modifier_DEPS) $(CHROMESHADES_INJECTED_shades_modifier_SRCS)

CHROMESHADES_INJECTED_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_CHROME_extension_bridge_FILES) $(CHROMESHADES_INJECTED_base_modifier_FILES) $(CHROMESHADES_INJECTED_shades_modifier_FILES))
CHROMESHADES_INJECTED_loader_SRCS = chromeshades/injected/loader.js
CHROMESHADES_INJECTED_loader_FILES = $(CHROMESHADES_INJECTED_loader_DEPS) $(CHROMESHADES_INJECTED_loader_SRCS)

CHROMESHADES_INJECTED_binary_DEPS = $(CHROMESHADES_INJECTED_loader_FILES)
chromeshades/injected/binary.js_FILES = chromeshades/injected/binary.js
chromeshades/injected/binary.js: $(CHROMESHADES_INJECTED_binary_DEPS)
	@echo Building Javascript binary chromeshades/injected/binary.js
	@$(CLOSURE_COMPILER) --js $(CHROMESHADES_INJECTED_binary_DEPS) --js_output_file chromeshades/injected/binary.js


CHROMESHADES_INJECTED_binary.js_FILES = chromeshades/injected/binary.js
ACCESSERRORS_accesserrors_DEPS = $(CLOSURE_base_FILES)
ACCESSERRORS_accesserrors_SRCS = accesserrors/accesserrors.js
ACCESSERRORS_accesserrors_FILES = $(ACCESSERRORS_accesserrors_DEPS) $(ACCESSERRORS_accesserrors_SRCS)

CHROMESHADES_INJECTED_accesserrors_injected_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ACCESSERRORS_accesserrors_FILES))
CHROMESHADES_INJECTED_accesserrors_injected_SRCS = chromeshades/injected/accesserrors_injected.js
CHROMESHADES_INJECTED_accesserrors_injected_FILES = $(CHROMESHADES_INJECTED_accesserrors_injected_DEPS) $(CHROMESHADES_INJECTED_accesserrors_injected_SRCS)

CHROMESHADES_INJECTED_accesserrors_binary_DEPS = $(CHROMESHADES_INJECTED_accesserrors_injected_FILES)
chromeshades/injected/accesserrors_binary.js_FILES = chromeshades/injected/accesserrors_binary.js
chromeshades/injected/accesserrors_binary.js: $(CHROMESHADES_INJECTED_accesserrors_binary_DEPS)
	@echo Building Javascript binary chromeshades/injected/accesserrors_binary.js
	@$(CLOSURE_COMPILER) --js $(CHROMESHADES_INJECTED_accesserrors_binary_DEPS) --js_output_file chromeshades/injected/accesserrors_binary.js


CHROMESHADES_INJECTED_accesserrors_binary.js_FILES = chromeshades/injected/accesserrors_binary.js
CHROMESHADES_BACKGROUND_toggle_DEPS = $(CLOSURE_base_FILES)
CHROMESHADES_BACKGROUND_toggle_SRCS = chromeshades/background/toggle.js
CHROMESHADES_BACKGROUND_toggle_FILES = $(CHROMESHADES_BACKGROUND_toggle_DEPS) $(CHROMESHADES_BACKGROUND_toggle_SRCS)

CHROMESHADES_BACKGROUND_background_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(HOST_CHROME_extension_bridge_FILES) $(CHROMESHADES_BACKGROUND_toggle_FILES))
CHROMESHADES_BACKGROUND_background_SRCS = chromeshades/background/background.js
CHROMESHADES_BACKGROUND_background_FILES = $(CHROMESHADES_BACKGROUND_background_DEPS) $(CHROMESHADES_BACKGROUND_background_SRCS)

CHROMESHADES_BACKGROUND_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CHROMESHADES_BACKGROUND_background_FILES))
CHROMESHADES_BACKGROUND_loader_SRCS = chromeshades/background/loader.js
CHROMESHADES_BACKGROUND_loader_FILES = $(CHROMESHADES_BACKGROUND_loader_DEPS) $(CHROMESHADES_BACKGROUND_loader_SRCS)

CHROMESHADES_BACKGROUND_binary_DEPS = $(CHROMESHADES_BACKGROUND_loader_FILES)
chromeshades/background/binary.js_FILES = chromeshades/background/binary.js
chromeshades/background/binary.js: $(CHROMESHADES_BACKGROUND_binary_DEPS)
	@echo Building Javascript binary chromeshades/background/binary.js
	@$(CLOSURE_COMPILER) --js $(CHROMESHADES_BACKGROUND_binary_DEPS) --js_output_file chromeshades/background/binary.js


CHROMESHADES_BACKGROUND_binary.js_FILES = chromeshades/background/binary.js
CHROMESHADES_BACKGROUND_html_files_FILES = $(wildcard chromeshades/background/*.html)
CHROMESHADES_BACKGROUND_html_files: $(CHROMESHADES_BACKGROUND_html_files_FILES)

CHROMESHADES_DEVTOOLS_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(ACCESSERRORS_accesserrors_FILES))
CHROMESHADES_DEVTOOLS_loader_SRCS = chromeshades/devtools/loader.js
CHROMESHADES_DEVTOOLS_loader_FILES = $(CHROMESHADES_DEVTOOLS_loader_DEPS) $(CHROMESHADES_DEVTOOLS_loader_SRCS)

CHROMESHADES_DEVTOOLS_binary_DEPS = $(CHROMESHADES_DEVTOOLS_loader_FILES)
chromeshades/devtools/binary.js_FILES = chromeshades/devtools/binary.js
chromeshades/devtools/binary.js: $(CHROMESHADES_DEVTOOLS_binary_DEPS)
	@echo Building Javascript binary chromeshades/devtools/binary.js
	@$(CLOSURE_COMPILER) --js $(CHROMESHADES_DEVTOOLS_binary_DEPS) --js_output_file chromeshades/devtools/binary.js


CHROMESHADES_DEVTOOLS_binary.js_FILES = chromeshades/devtools/binary.js
CHROMESHADES_DEVTOOLS_html_files_FILES = $(wildcard chromeshades/devtools/*.html)
CHROMESHADES_DEVTOOLS_html_files: $(CHROMESHADES_DEVTOOLS_html_files_FILES)

CHROMESHADES_png_files_FILES = $(wildcard chromeshades/*.png)
CHROMESHADES_png_files: $(CHROMESHADES_png_files_FILES)

chromeshades_deploy_fs_out_SRCS = $(call uniq, $(CHROMESHADES_manifest_compiled_manifest/manifest.json_FILES) $(CHROMESHADES_INJECTED_binary.js_FILES) $(CHROMESHADES_INJECTED_accesserrors_binary.js_FILES) $(CHROMESHADES_BACKGROUND_binary.js_FILES) chromeshades/background/selector.js $(CHROMESHADES_BACKGROUND_html_files_FILES) $(CHROMESHADES_DEVTOOLS_binary.js_FILES) $(CHROMESHADES_DEVTOOLS_html_files_FILES) chromeshades/chromeshades.css $(CHROMESHADES_png_files_FILES) closure/closure_preinit.js)
chromeshades_deploy_fs_out_FILES = chromeshades_deploy_fs_out
chromeshades_deploy_fs_out: $(chromeshades_deploy_fs_out_SRCS)
	@echo Building Fileset chromeshades_deploy_fs_out
	@mkdir -p $(chromeshades_deploy_fs_out_FILES)
	@cp $(CHROMESHADES_manifest_compiled_manifest/manifest.json_FILES) chromeshades_deploy_fs_out/
	@mkdir -p chromeshades_deploy_fs_out/chromeshades/injected
	@cp $(CHROMESHADES_INJECTED_binary.js_FILES) chromeshades_deploy_fs_out/chromeshades/injected
	@mkdir -p chromeshades_deploy_fs_out/chromeshades/injected
	@cp $(CHROMESHADES_INJECTED_accesserrors_binary.js_FILES) chromeshades_deploy_fs_out/chromeshades/injected
	@mkdir -p chromeshades_deploy_fs_out/chromeshades/background
	@cp $(CHROMESHADES_BACKGROUND_binary.js_FILES) chromeshades_deploy_fs_out/chromeshades/background
	@mkdir -p chromeshades_deploy_fs_out/chromeshades/background
	@cp chromeshades/background/selector.js chromeshades_deploy_fs_out/chromeshades/background
	@mkdir -p chromeshades_deploy_fs_out/chromeshades/background
	@cp $(CHROMESHADES_BACKGROUND_html_files_FILES) chromeshades_deploy_fs_out/chromeshades/background
	@mkdir -p chromeshades_deploy_fs_out/chromeshades/devtools
	@cp $(CHROMESHADES_DEVTOOLS_binary.js_FILES) chromeshades_deploy_fs_out/chromeshades/devtools
	@mkdir -p chromeshades_deploy_fs_out/chromeshades/devtools
	@cp $(CHROMESHADES_DEVTOOLS_html_files_FILES) chromeshades_deploy_fs_out/chromeshades/devtools
	@mkdir -p chromeshades_deploy_fs_out/chromeshades
	@cp chromeshades/chromeshades.css chromeshades_deploy_fs_out/chromeshades
	@mkdir -p chromeshades_deploy_fs_out/chromeshades
	@cp $(CHROMESHADES_png_files_FILES) chromeshades_deploy_fs_out/chromeshades
	@cp closure/closure_preinit.js chromeshades_deploy_fs_out/

chromeshades_deploy_fs: chromeshades_deploy_fs_out
chromeshades_deploy_fs_FILES = $(chromeshades_deploy_fs_out_FILES)
chromeshades_deploy_crx_SRCS = $(call uniq, $(chromeshades_deploy_fs_FILES) private_keys/chromeshades.pem external/package.sh)
chromeshades_deploy_crx_FILES = chromeshades_deploy.crx
chromeshades_deploy.crx: $(chromeshades_deploy_crx_SRCS)
	@echo Generating file chromeshades_deploy.crx
	@external/package.sh --key private_keys/chromeshades.pem --src $(chromeshades_deploy_fs_FILES) --crx $@


CHROMESHADES_manifest_uncompiled_manifest_gen_SRCS = chromeshades/manifest.json
CHROMESHADES_manifest_uncompiled_manifest_gen_FILES = chromeshades/manifest_uncompiled_manifest/manifest.json
chromeshades/manifest_uncompiled_manifest/manifest.json: $(CHROMESHADES_manifest_uncompiled_manifest_gen_SRCS)
	@echo Generating file chromeshades/manifest_uncompiled_manifest/manifest.json
	@mkdir -p $(dir chromeshades/manifest_uncompiled_manifest/manifest.json)
	@cat $< >$@


CHROMESHADES_manifest_uncompiled_manifest/manifest.json_FILES = $(CHROMESHADES_manifest_uncompiled_manifest_gen_FILES)
chromeshades_deploy_uncompiled_fs_out_SRCS = $(CHROMESHADES_manifest_uncompiled_manifest/manifest.json_FILES)
chromeshades_deploy_uncompiled_fs_out_FILES = chromeshades_deploy_uncompiled_fs_out
chromeshades_deploy_uncompiled_fs_out: $(chromeshades_deploy_uncompiled_fs_out_SRCS)
	@echo Building Fileset chromeshades_deploy_uncompiled_fs_out
	@mkdir -p $(chromeshades_deploy_uncompiled_fs_out_FILES)
	@cp $(CHROMESHADES_manifest_uncompiled_manifest/manifest.json_FILES) chromeshades_deploy_uncompiled_fs_out/

chromeshades_deploy_uncompiled_fs: chromeshades_deploy_uncompiled_fs_out
chromeshades_deploy_uncompiled_fs_FILES = $(chromeshades_deploy_uncompiled_fs_out_FILES)
chromeshades: deps.js chromeshades_deploy_uncompiled_fs
	@echo Building unpacked Chrome extension for chromeshades
	@cp -a chromeshades_deploy_uncompiled_fs_out/* .

CARETBROWSING_manifestmanifest_gen_SRCS = caretbrowsing/manifest.json
CARETBROWSING_manifestmanifest_gen_FILES = caretbrowsing/manifest_compiled_manifest/manifest.json
caretbrowsing/manifest_compiled_manifest/manifest.json: $(CARETBROWSING_manifestmanifest_gen_SRCS)
	@echo Generating file caretbrowsing/manifest_compiled_manifest/manifest.json
	@mkdir -p $(dir caretbrowsing/manifest_compiled_manifest/manifest.json)
	@cat $< | sed -e 's/loader.js/LOADER.JS/' | grep -vE '^ *"[^ ]*.js"' | sed -e 's/LOADER.JS/binary.js/' >$@


CARETBROWSING_manifest_compiled_manifest/manifest.json_FILES = $(CARETBROWSING_manifestmanifest_gen_FILES)
CARETBROWSING_INJECTED_caretbrowsing_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(COMMON_cursor_FILES) $(COMMON_dom_util_FILES) $(COMMON_traverse_util_FILES))
CARETBROWSING_INJECTED_caretbrowsing_SRCS = caretbrowsing/injected/caretbrowsing.js
CARETBROWSING_INJECTED_caretbrowsing_FILES = $(CARETBROWSING_INJECTED_caretbrowsing_DEPS) $(CARETBROWSING_INJECTED_caretbrowsing_SRCS)

CARETBROWSING_INJECTED_loader_DEPS = $(call uniq, $(CLOSURE_base_FILES) $(CARETBROWSING_INJECTED_caretbrowsing_FILES))
CARETBROWSING_INJECTED_loader_SRCS = caretbrowsing/injected/loader.js
CARETBROWSING_INJECTED_loader_FILES = $(CARETBROWSING_INJECTED_loader_DEPS) $(CARETBROWSING_INJECTED_loader_SRCS)

CARETBROWSING_INJECTED_binary_DEPS = $(CARETBROWSING_INJECTED_loader_FILES)
caretbrowsing/injected/binary.js_FILES = caretbrowsing/injected/binary.js
caretbrowsing/injected/binary.js: $(CARETBROWSING_INJECTED_binary_DEPS)
	@echo Building Javascript binary caretbrowsing/injected/binary.js
	@$(CLOSURE_COMPILER) --js $(CARETBROWSING_INJECTED_binary_DEPS) --js_output_file caretbrowsing/injected/binary.js


CARETBROWSING_INJECTED_binary.js_FILES = caretbrowsing/injected/binary.js
CARETBROWSING_png_files_FILES = $(wildcard caretbrowsing/*.png)
CARETBROWSING_png_files: $(CARETBROWSING_png_files_FILES)

caretbrowsing_deploy_fs_out_SRCS = $(call uniq, $(CARETBROWSING_manifest_compiled_manifest/manifest.json_FILES) $(CARETBROWSING_INJECTED_binary.js_FILES) $(CARETBROWSING_png_files_FILES) caretbrowsing/background/background.html caretbrowsing/background/background.js closure/closure_preinit.js)
caretbrowsing_deploy_fs_out_FILES = caretbrowsing_deploy_fs_out
caretbrowsing_deploy_fs_out: $(caretbrowsing_deploy_fs_out_SRCS)
	@echo Building Fileset caretbrowsing_deploy_fs_out
	@mkdir -p $(caretbrowsing_deploy_fs_out_FILES)
	@cp $(CARETBROWSING_manifest_compiled_manifest/manifest.json_FILES) caretbrowsing_deploy_fs_out/
	@mkdir -p caretbrowsing_deploy_fs_out/caretbrowsing/injected
	@cp $(CARETBROWSING_INJECTED_binary.js_FILES) caretbrowsing_deploy_fs_out/caretbrowsing/injected
	@mkdir -p caretbrowsing_deploy_fs_out/caretbrowsing
	@cp $(CARETBROWSING_png_files_FILES) caretbrowsing_deploy_fs_out/caretbrowsing
	@mkdir -p caretbrowsing_deploy_fs_out/caretbrowsing/background
	@cp caretbrowsing/background/background.html caretbrowsing_deploy_fs_out/caretbrowsing/background
	@mkdir -p caretbrowsing_deploy_fs_out/caretbrowsing/background
	@cp caretbrowsing/background/background.js caretbrowsing_deploy_fs_out/caretbrowsing/background
	@cp closure/closure_preinit.js caretbrowsing_deploy_fs_out/

caretbrowsing_deploy_fs: caretbrowsing_deploy_fs_out
caretbrowsing_deploy_fs_FILES = $(caretbrowsing_deploy_fs_out_FILES)
caretbrowsing_deploy_crx_SRCS = $(call uniq, $(caretbrowsing_deploy_fs_FILES) private_keys/caretbrowsing.pem external/package.sh)
caretbrowsing_deploy_crx_FILES = caretbrowsing_deploy.crx
caretbrowsing_deploy.crx: $(caretbrowsing_deploy_crx_SRCS)
	@echo Generating file caretbrowsing_deploy.crx
	@external/package.sh --key private_keys/caretbrowsing.pem --src $(caretbrowsing_deploy_fs_FILES) --crx $@


CARETBROWSING_manifest_uncompiled_manifest_gen_SRCS = caretbrowsing/manifest.json
CARETBROWSING_manifest_uncompiled_manifest_gen_FILES = caretbrowsing/manifest_uncompiled_manifest/manifest.json
caretbrowsing/manifest_uncompiled_manifest/manifest.json: $(CARETBROWSING_manifest_uncompiled_manifest_gen_SRCS)
	@echo Generating file caretbrowsing/manifest_uncompiled_manifest/manifest.json
	@mkdir -p $(dir caretbrowsing/manifest_uncompiled_manifest/manifest.json)
	@cat $< >$@


CARETBROWSING_manifest_uncompiled_manifest/manifest.json_FILES = $(CARETBROWSING_manifest_uncompiled_manifest_gen_FILES)
caretbrowsing_deploy_uncompiled_fs_out_SRCS = $(CARETBROWSING_manifest_uncompiled_manifest/manifest.json_FILES)
caretbrowsing_deploy_uncompiled_fs_out_FILES = caretbrowsing_deploy_uncompiled_fs_out
caretbrowsing_deploy_uncompiled_fs_out: $(caretbrowsing_deploy_uncompiled_fs_out_SRCS)
	@echo Building Fileset caretbrowsing_deploy_uncompiled_fs_out
	@mkdir -p $(caretbrowsing_deploy_uncompiled_fs_out_FILES)
	@cp $(CARETBROWSING_manifest_uncompiled_manifest/manifest.json_FILES) caretbrowsing_deploy_uncompiled_fs_out/

caretbrowsing_deploy_uncompiled_fs: caretbrowsing_deploy_uncompiled_fs_out
caretbrowsing_deploy_uncompiled_fs_FILES = $(caretbrowsing_deploy_uncompiled_fs_out_FILES)
caretbrowsing: deps.js caretbrowsing_deploy_uncompiled_fs
	@echo Building unpacked Chrome extension for caretbrowsing
	@cp -a caretbrowsing_deploy_uncompiled_fs_out/* .

CVOXEXT_manifestmanifest_gen_SRCS = cvoxext/manifest.json
CVOXEXT_manifestmanifest_gen_FILES = cvoxext/manifest_compiled_manifest/manifest.json
cvoxext/manifest_compiled_manifest/manifest.json: $(CVOXEXT_manifestmanifest_gen_SRCS)
	@echo Generating file cvoxext/manifest_compiled_manifest/manifest.json
	@mkdir -p $(dir cvoxext/manifest_compiled_manifest/manifest.json)
	@cat $< | sed -e 's/loader.js/LOADER.JS/' | grep -vE '^ *"[^ ]*.js"' | sed -e 's/LOADER.JS/binary.js/' >$@


CVOXEXT_manifest_compiled_manifest/manifest.json_FILES = $(CVOXEXT_manifestmanifest_gen_FILES)
CVOXEXT_loader_SRCS = cvoxext/loader.js
CVOXEXT_loader_FILES = $(CVOXEXT_loader_SRCS)

CVOXEXT_binary_DEPS = $(CVOXEXT_loader_FILES)
cvoxext/binary.js_FILES = cvoxext/binary.js
cvoxext/binary.js: $(CVOXEXT_binary_DEPS)
	@echo Building Javascript binary cvoxext/binary.js
	@$(CLOSURE_COMPILER) --js $(CVOXEXT_binary_DEPS) --js_output_file cvoxext/binary.js


CVOXEXT_binary.js_FILES = cvoxext/binary.js
cvoxext_deploy_fs_out_SRCS = $(call uniq, $(CVOXEXT_manifest_compiled_manifest/manifest.json_FILES) $(CVOXEXT_binary.js_FILES) cvoxext/common/main.js cvoxext/common/util.js cvoxext/common/speakable.js cvoxext/common/speakable_manager.js cvoxext/common/speakable_parser.js cvoxext/common/traverse_manager.js cvoxext/common/listeners.js cvoxext/common/extension.js cvoxext/extensions/books.js cvoxext/extensions/calculator.js cvoxext/extensions/calendar.js cvoxext/extensions/drive.js cvoxext/extensions/finance.js cvoxext/extensions/finance_stock_screener.js cvoxext/extensions/gmail.js cvoxext/extensions/news.js cvoxext/extensions/plus.js external/sprintf-0.7-beta1.js)
cvoxext_deploy_fs_out_FILES = cvoxext_deploy_fs_out
cvoxext_deploy_fs_out: $(cvoxext_deploy_fs_out_SRCS)
	@echo Building Fileset cvoxext_deploy_fs_out
	@mkdir -p $(cvoxext_deploy_fs_out_FILES)
	@cp $(CVOXEXT_manifest_compiled_manifest/manifest.json_FILES) cvoxext_deploy_fs_out/
	@mkdir -p cvoxext_deploy_fs_out/cvoxext
	@cp $(CVOXEXT_binary.js_FILES) cvoxext_deploy_fs_out/cvoxext
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/main.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/util.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/speakable.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/speakable_manager.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/speakable_parser.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/traverse_manager.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/listeners.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/extension.js cvoxext_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/books.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/calculator.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/calendar.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/drive.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/finance.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/finance_stock_screener.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/gmail.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/news.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/plus.js cvoxext_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_deploy_fs_out/cvoxext/common
	@cp external/sprintf-0.7-beta1.js cvoxext_deploy_fs_out/cvoxext/common

cvoxext_deploy_fs: cvoxext_deploy_fs_out
cvoxext_deploy_fs_FILES = $(cvoxext_deploy_fs_out_FILES)
cvoxext_deploy_crx_SRCS = $(call uniq, $(cvoxext_deploy_fs_FILES) private_keys/cvoxext.pem external/package.sh)
cvoxext_deploy_crx_FILES = cvoxext_deploy.crx
cvoxext_deploy.crx: $(cvoxext_deploy_crx_SRCS)
	@echo Generating file cvoxext_deploy.crx
	@external/package.sh --key private_keys/cvoxext.pem --src $(cvoxext_deploy_fs_FILES) --crx $@


CVOXEXT_manifest_uncompiled_manifest_gen_SRCS = cvoxext/manifest.json
CVOXEXT_manifest_uncompiled_manifest_gen_FILES = cvoxext/manifest_uncompiled_manifest/manifest.json
cvoxext/manifest_uncompiled_manifest/manifest.json: $(CVOXEXT_manifest_uncompiled_manifest_gen_SRCS)
	@echo Generating file cvoxext/manifest_uncompiled_manifest/manifest.json
	@mkdir -p $(dir cvoxext/manifest_uncompiled_manifest/manifest.json)
	@cat $< >$@


CVOXEXT_manifest_uncompiled_manifest/manifest.json_FILES = $(CVOXEXT_manifest_uncompiled_manifest_gen_FILES)
cvoxext_deploy_uncompiled_fs_out_SRCS = $(call uniq, $(CVOXEXT_manifest_uncompiled_manifest/manifest.json_FILES) external/sprintf-0.7-beta1.js)
cvoxext_deploy_uncompiled_fs_out_FILES = cvoxext_deploy_uncompiled_fs_out
cvoxext_deploy_uncompiled_fs_out: $(cvoxext_deploy_uncompiled_fs_out_SRCS)
	@echo Building Fileset cvoxext_deploy_uncompiled_fs_out
	@mkdir -p $(cvoxext_deploy_uncompiled_fs_out_FILES)
	@cp $(CVOXEXT_manifest_uncompiled_manifest/manifest.json_FILES) cvoxext_deploy_uncompiled_fs_out/
	@mkdir -p cvoxext_deploy_uncompiled_fs_out/cvoxext/common
	@cp external/sprintf-0.7-beta1.js cvoxext_deploy_uncompiled_fs_out/cvoxext/common

cvoxext_deploy_uncompiled_fs: cvoxext_deploy_uncompiled_fs_out
cvoxext_deploy_uncompiled_fs_FILES = $(cvoxext_deploy_uncompiled_fs_out_FILES)
cvoxext: deps.js cvoxext_deploy_uncompiled_fs
	@echo Building unpacked Chrome extension for cvoxext
	@cp -a cvoxext_deploy_uncompiled_fs_out/* .

CVOXEXT_internal_manifestmanifest_gen_SRCS = cvoxext/internal_manifest.json
CVOXEXT_internal_manifestmanifest_gen_FILES = cvoxext/internal_manifest_compiled_manifest/manifest.json
cvoxext/internal_manifest_compiled_manifest/manifest.json: $(CVOXEXT_internal_manifestmanifest_gen_SRCS)
	@echo Generating file cvoxext/internal_manifest_compiled_manifest/manifest.json
	@mkdir -p $(dir cvoxext/internal_manifest_compiled_manifest/manifest.json)
	@cat $< | sed -e 's/loader.js/LOADER.JS/' | grep -vE '^ *"[^ ]*.js"' | sed -e 's/LOADER.JS/binary.js/' >$@


CVOXEXT_internal_manifest_compiled_manifest/manifest.json_FILES = $(CVOXEXT_internal_manifestmanifest_gen_FILES)
CVOXEXT_internal_loader_SRCS = cvoxext/internal_loader.js
CVOXEXT_internal_loader_FILES = $(CVOXEXT_internal_loader_SRCS)

CVOXEXT_internal_binary_DEPS = $(CVOXEXT_internal_loader_FILES)
cvoxext/internal_binary.js_FILES = cvoxext/internal_binary.js
cvoxext/internal_binary.js: $(CVOXEXT_internal_binary_DEPS)
	@echo Building Javascript binary cvoxext/internal_binary.js
	@$(CLOSURE_COMPILER) --js $(CVOXEXT_internal_binary_DEPS) --js_output_file cvoxext/internal_binary.js


CVOXEXT_internal_binary.js_FILES = cvoxext/internal_binary.js
cvoxext_internal_deploy_fs_out_SRCS = $(call uniq, $(CVOXEXT_internal_manifest_compiled_manifest/manifest.json_FILES) $(CVOXEXT_internal_binary.js_FILES) cvoxext/common/main.js cvoxext/common/util.js cvoxext/common/speakable.js cvoxext/common/speakable_manager.js cvoxext/common/speakable_parser.js cvoxext/common/traverse_manager.js cvoxext/common/listeners.js cvoxext/common/extension.js cvoxext/extensions/buganizer.js cvoxext/extensions/books.js cvoxext/extensions/calculator.js cvoxext/extensions/calendar.js cvoxext/extensions/drive.js cvoxext/extensions/finance.js cvoxext/extensions/finance_stock_screener.js cvoxext/extensions/gmail.js cvoxext/extensions/news.js cvoxext/extensions/plus.js external/sprintf-0.7-beta1.js)
cvoxext_internal_deploy_fs_out_FILES = cvoxext_internal_deploy_fs_out
cvoxext_internal_deploy_fs_out: $(cvoxext_internal_deploy_fs_out_SRCS)
	@echo Building Fileset cvoxext_internal_deploy_fs_out
	@mkdir -p $(cvoxext_internal_deploy_fs_out_FILES)
	@cp $(CVOXEXT_internal_manifest_compiled_manifest/manifest.json_FILES) cvoxext_internal_deploy_fs_out/
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext
	@cp $(CVOXEXT_internal_binary.js_FILES) cvoxext_internal_deploy_fs_out/cvoxext
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/main.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/util.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/speakable.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/speakable_manager.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/speakable_parser.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/traverse_manager.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/listeners.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp cvoxext/common/extension.js cvoxext_internal_deploy_fs_out/cvoxext/common
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/buganizer.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/books.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/calculator.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/calendar.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/drive.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/finance.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/finance_stock_screener.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/gmail.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/news.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@cp cvoxext/extensions/plus.js cvoxext_internal_deploy_fs_out/cvoxext/extensions
	@mkdir -p cvoxext_internal_deploy_fs_out/cvoxext/common
	@cp external/sprintf-0.7-beta1.js cvoxext_internal_deploy_fs_out/cvoxext/common

cvoxext_internal_deploy_fs: cvoxext_internal_deploy_fs_out
cvoxext_internal_deploy_fs_FILES = $(cvoxext_internal_deploy_fs_out_FILES)
cvoxext_internal_deploy_crx_SRCS = $(call uniq, $(cvoxext_internal_deploy_fs_FILES) private_keys/cvoxext_internal.pem external/package.sh)
cvoxext_internal_deploy_crx_FILES = cvoxext_internal_deploy.crx
cvoxext_internal_deploy.crx: $(cvoxext_internal_deploy_crx_SRCS)
	@echo Generating file cvoxext_internal_deploy.crx
	@external/package.sh --key private_keys/cvoxext_internal.pem --src $(cvoxext_internal_deploy_fs_FILES) --crx $@


CVOXEXT_internal_manifest_uncompiled_manifest_gen_SRCS = cvoxext/internal_manifest.json
CVOXEXT_internal_manifest_uncompiled_manifest_gen_FILES = cvoxext/internal_manifest_uncompiled_manifest/manifest.json
cvoxext/internal_manifest_uncompiled_manifest/manifest.json: $(CVOXEXT_internal_manifest_uncompiled_manifest_gen_SRCS)
	@echo Generating file cvoxext/internal_manifest_uncompiled_manifest/manifest.json
	@mkdir -p $(dir cvoxext/internal_manifest_uncompiled_manifest/manifest.json)
	@cat $< >$@


CVOXEXT_internal_manifest_uncompiled_manifest/manifest.json_FILES = $(CVOXEXT_internal_manifest_uncompiled_manifest_gen_FILES)
cvoxext_internal_deploy_uncompiled_fs_out_SRCS = $(call uniq, $(CVOXEXT_internal_manifest_uncompiled_manifest/manifest.json_FILES) external/sprintf-0.7-beta1.js)
cvoxext_internal_deploy_uncompiled_fs_out_FILES = cvoxext_internal_deploy_uncompiled_fs_out
cvoxext_internal_deploy_uncompiled_fs_out: $(cvoxext_internal_deploy_uncompiled_fs_out_SRCS)
	@echo Building Fileset cvoxext_internal_deploy_uncompiled_fs_out
	@mkdir -p $(cvoxext_internal_deploy_uncompiled_fs_out_FILES)
	@cp $(CVOXEXT_internal_manifest_uncompiled_manifest/manifest.json_FILES) cvoxext_internal_deploy_uncompiled_fs_out/
	@mkdir -p cvoxext_internal_deploy_uncompiled_fs_out/cvoxext/common
	@cp external/sprintf-0.7-beta1.js cvoxext_internal_deploy_uncompiled_fs_out/cvoxext/common

cvoxext_internal_deploy_uncompiled_fs: cvoxext_internal_deploy_uncompiled_fs_out
cvoxext_internal_deploy_uncompiled_fs_FILES = $(cvoxext_internal_deploy_uncompiled_fs_out_FILES)
cvoxext_internal: deps.js cvoxext_internal_deploy_uncompiled_fs
	@echo Building unpacked Chrome extension for cvoxext_internal
	@cp -a cvoxext_internal_deploy_uncompiled_fs_out/* .

clean:
	rm -rf chromevox/messages/i18n_messages_localized__en.js chromevox/messages/_locales/en/messages.json host/testing/test_messages.js chromeVoxChromePageScript.js chromeVoxKbExplorerScript.js chromeVoxTestsScript.js chromeVoxChromeBackgroundScript.js chromeVoxChromeOptionsScript.js androidVoxDev.js clankVoxDev.js chromeshades/injected/binary.js chromeshades/injected/accesserrors_binary.js chromeVoxChromePageScript.js chromeVoxKbExplorerScript.js chromeVoxTestsScript.js chromeVoxChromeBackgroundScript.js chromeVoxChromeOptionsScript.js androidVoxDev.js clankVoxDev.js chromevox/manifest_compiled_manifest/manifest.json chromevox/manifest_uncompiled_manifest/manifest.json chromevox_deploy_fs_out chromevox_deploy_fs chromevox_deploy_uncompiled_fs_out chromevox_deploy_uncompiled_fs chromevox_deploy.crx chromevis/background/background.js chromevis/injected/binary.js chromevis/i18n_messages_localized__en.js chromevis/_locales/en/messages.json chromevis/manifest_compiled_manifest/manifest.json chromevis/manifest_uncompiled_manifest/manifest.json chromevis_deploy_fs_out chromevis_deploy_fs chromevis_deploy_uncompiled_fs_out chromevis_deploy_uncompiled_fs chromevis_deploy.crx caretbrowsing/injected/binary.js caretbrowsing/manifest_compiled_manifest/manifest.json caretbrowsing/manifest_uncompiled_manifest/manifest.json caretbrowsing_deploy_fs_out caretbrowsing_deploy_fs caretbrowsing_deploy_uncompiled_fs_out caretbrowsing_deploy_uncompiled_fs caretbrowsing_deploy.crx chromeshades/background/binary.js chromeshades/devtools/binary.js chromeshades/manifest_compiled_manifest/manifest.json chromeshades/manifest_uncompiled_manifest/manifest.json chromeshades_deploy_fs_out chromeshades_deploy_fs chromeshades_deploy_uncompiled_fs_out chromeshades_deploy_uncompiled_fs chromeshades_deploy.crx cvoxext/manifest_compiled_manifest/manifest.json cvoxext/manifest_uncompiled_manifest/manifest.json cvoxext/internal_manifest_compiled_manifest/manifest.json cvoxext/internal_manifest_uncompiled_manifest/manifest.json cvoxext/binary.js cvoxext/internal_binary.js cvoxext_deploy_fs_out cvoxext_deploy_fs cvoxext_deploy_uncompiled_fs_out cvoxext_deploy_uncompiled_fs cvoxext_deploy.crx cvoxext_internal_deploy_fs_out cvoxext_internal_deploy_fs cvoxext_internal_deploy_uncompiled_fs_out cvoxext_internal_deploy_uncompiled_fs cvoxext_internal_deploy.crx chromevox_deploy_fs_out chromevox_deploy_fs chromevox_deploy_uncompiled_fs_out chromevox_deploy_uncompiled_fs chromevox_deploy.crx chromevis_deploy_fs_out chromevis_deploy_fs chromevis_deploy_uncompiled_fs_out chromevis_deploy_uncompiled_fs chromevis_deploy.crx caretbrowsing_deploy_fs_out caretbrowsing_deploy_fs caretbrowsing_deploy_uncompiled_fs_out caretbrowsing_deploy_uncompiled_fs caretbrowsing_deploy.crx chromeshades_deploy_fs_out chromeshades_deploy_fs chromeshades_deploy_uncompiled_fs_out chromeshades_deploy_uncompiled_fs chromeshades_deploy.crx cvoxext_deploy_fs_out cvoxext_deploy_fs cvoxext_deploy_uncompiled_fs_out cvoxext_deploy_uncompiled_fs cvoxext_deploy.crx cvoxext_internal_deploy_fs_out cvoxext_internal_deploy_fs cvoxext_internal_deploy_uncompiled_fs_out cvoxext_internal_deploy_uncompiled_fs cvoxext_internal_deploy.crx

all: chromevox cvoxext_internal_deploy.crx cvoxext chromeshades_deploy.crx androidVoxDev.js chromevox_deploy.crx caretbrowsing chromeshades chromevis cvoxext_internal caretbrowsing_deploy.crx chromevis_deploy.crx clankVoxDev.js cvoxext_deploy.crx

