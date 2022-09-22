import 'package:yaml/yaml.dart' show loadYaml;
import 'dart:convert';

Map parse(YamlMap) {
  Map<String, dynamic> tree = {};
  int number = 0;
  for (var element in YamlMap) {
    var test;
    var handleResult;

    try {
      test = element['type'];
      if (test == "markdown") {
        handleResult = handleContent(element);
      } else {
        handleResult = handleType(element);
      }
    } catch (e) {
      // element['type'] not found exception
    }
    tree.putIfAbsent("child${number++}", () => handleResult);
  }
  return tree;
}

Map handleType(element) {
  var type = element['type'];
  switch (type) {
    case "custom:mod-card":
      return handleType(element['card']);
    case "custom:swipe-card":
      return {"swipe card": parse(element['cards'])};
    case "vertical-stack":
      return {"vertical stack": parse(element['cards'])};
    case "custom:layout-card":
      return {"layout": parse(element['cards'])};
    case "custom:button-card":
      return {
        "type": "button",
        "name": element['name'],
        "template": element['template'],
        "entity": element['entity'],
      };
    case "custom:mushroom-cover-card":
      return {
        "type": "mushroom-cover-card",
        "name": element['name'],
        "entity": element['entity'],
        "icon": element['icon'],
        "show_buttons_control": element["show_buttons_control"],
        "show_position_control": element["show_position_control"],
      };
    case "custom:shutter-card":
      return {
        "type": "shutter card",
        "entities": {
          "entity": element['entities'][0]['entity'],
          "name": element['entities'][0]['name'],
        }
      };
    case "custom:state-switch":
      return {
        "type": "state-switch",
        "entity": element['entity'],
        "states": {
          "lights": handleType(element["states"]['lights']),
          "shutter": handleType(element["states"]['shutter']),
          "ac": handleType(element["states"]['ac'])
        }
      };
  }

  return {};
}

Map handleContent(element) {
  return {"text": element['content']};
}

Map handleIncludes(element) {
  return {};
}

void main() {
  var doc = loadYaml('''
pages:
  - title: Bedroom 3
    visible:
      - user: 94e543e26b354203820198c942f1bf48
    path: first-Bedroom_3
    type: custom:grid-layout
    badges: []
    cards:
      - type: custom:mod-card
        view_layout:
          grid-area: sidebar
        card_mod:
          style: |
            ha-card {
              background-color: transparent;
              width: 100%;
              margin: 0px;
              padding: 0px;
              height: 330px;
              box-shadow: none !important;
              background-repeat: no-repeat;
              background-position: center center;
              background-size: cover;
              border-radius: 0px 0px 30px 30px;
            }
            @media only screen and (min-width: 0px) {
              ha-card {
                background-image: url("/local/Home-Images/kitchen.png");
              }
            }
            @media only screen and (min-width: 768px) {
              ha-card {
                background-image: url("/local/Home-Images/kitchen.png");
              }
            }
            @media only screen and (min-width: 992px) {
              ha-card {
                background-image: url("/local/Home-Images/kitchen.png");
                height: 330px;
              }
            }
        card:
          type: custom:mod-card
          card_mod: 
            style: |
              ha-card {
                background: linear-gradient(0deg, #06090F 0%, rgba(0,0,0,0.3475140056022409) 90%);
              // backdrop-filter: blur(2px);
                box-shadow: none;
                height: 333px;
                border-radius: 0px 0px 25px 25px;
                width: 100%;
                margin: 0px;
                padding: 0px;
                transition: 2s ease;
              }
              @media only screen and (min-width: 992px) {
                ha-card {
                  height: 332px;
                }
              }
          card:
            type: custom:layout-card
            layout_type: grid
            layout: 
              grid-gap: 0px
              grid-template-columns: 40px 3fr 1fr
              grid-template-rows: 40px 130px 90px
              grid-template-areas: |
                "back weather  extras"
                ".  text  text"
                "scene scene scene"
            cards:
              - type: custom:button-card
                view_layout:
                  grid-area: back
                template: back_home
              - type: markdown
                content: >
                  # Bedroom 3
                view_layout:
                  grid-area: text
                style: &Room_Page_Header_Markdown_Style |
                  ha-card {
                    background-color: transparent;
                    box-shadow: 0px 0px transparent;
                    text-align: center;
                    display: flex;
                    align-items: center;
                    font-size: 15px;
                    font-weight: normal;
                    padding-right: 10px;
                    transition: 0s;
                  }
                  @media only screen and (min-width: 0px) {
                    ha-card {
                      font-size: 16px;
                      lign-items: center;
                    }
                  }
                  @media only screen and (min-width: 768px) {
                    ha-card {
                      font-size: 16px;
                    }
                  }
                  @media only screen and (min-width: 992px) {
                    ha-card {
                      font-size: 25px;
                      
                    }
                  }
              - type: custom:swipe-card
                view_layout:
                  grid-area: scene

                start_card: 1
                parameters:
                  centeredSlides: false
                  slidesPerView: auto
                  spaceBetween: 10
                cards:

                        - type: custom:button-card
                          entity: script.bedroom_3_off
                          name:  Room Off
                          custom_fields:
                            scene: |
                              [[[
                                return `<ha-icon
                                  icon="mdi:movie-off"
                                  style="width: 20px; height: 25px; color: rgba(0,0,0,0.7); ">
                                  </ha-icon>`
                              ]]]
                          template: scene_button
                        - type: custom:button-card
                          entity: script.bedroom_3_relax
                          name:  Relax Mode
                          custom_fields:
                            scene: |
                              [[[
                                return `<ha-icon
                                  icon="mdi:hand-heart"
                                  style="width: 20px; height: 25px; color: rgba(0,0,0,0.7); ">
                                  </ha-icon>`
                              ]]]
                          template: scene_button
                        - type: custom:button-card
                          entity: script.bedroom_3_sleeping
                          name:  Sleeping Mode
                          custom_fields:
                            scene: |
                              [[[
                                return `<ha-icon
                                  icon="mdi:sleep"
                                  style="width: 20px; height: 25px; color: rgba(0,0,0,0.7); ">
                                  </ha-icon>`
                              ]]]
                          template: scene_button
                        - type: custom:button-card
                          entity: script.bedroom_3_lights_on
                          name:  Lights On
                          custom_fields:
                            scene: |
                              [[[
                                return `<ha-icon
                                  icon="hue:bulb-group-sultan-lightstrip"
                                  style="width: 20px; height: 25px; color: rgba(0,0,0,0.7); ">
                                  </ha-icon>`
                              ]]]
                          template: scene_button
                        - type: custom:button-card
                          entity: script.bedroom_3_lights_off
                          name:  Lights Off
                          custom_fields:
                            scene: |
                              [[[
                                return `<ha-icon
                                  icon="hue:bulb-group-sultan-lightstrip-off"
                                  style="width: 20px; height: 25px; color: rgba(0,0,0,0.7); ">
                                  </ha-icon>`
                              ]]]

                          template: scene_button
                        - type: custom:button-card
                          entity: script.bedroom_3_covers_on
                          name:  Covers On
                          custom_fields:
                            scene: |
                              [[[
                                return `<ha-icon
                                  icon="mdi:blinds-open"
                                  style="width: 20px; height: 25px; color: rgba(0,0,0,0.7); ">
                                  </ha-icon>`
                              ]]]

                          template: scene_button
                        - type: custom:button-card
                          entity: script.bedroom_3_covers_on_2
                          name:  Covers Off
                          custom_fields:
                            scene: |
                              [[[
                                return `<ha-icon
                                  icon="mdi:blinds"
                                  style="width: 20px; height: 25px; color: rgba(0,0,0,0.7); ">
                                  </ha-icon>`
                              ]]]
                          template: scene_button

              - !include popup/menu-all-devices-popup.yaml


      - type: vertical-stack
        cards:

          - type: custom:mod-card
            style: |
              ha-card {
                //background: var( --ha-card-background, var(--card-background-color, white) );
                border-radius: 30px;
                  }
            card:
              type: custom:state-switch
              entity: input_select.bedroom_3
              default: lights

              transition_time: 250
              states:
                lights:
                  type: custom:layout-card
                  layout_type: grid
                  layout:
                    grid-template-columns: repeat(auto-fill, minmax(115px, auto))
                  cards:
                    - type: custom:button-card
                      entity: light.spot_lights_bedroom_3_ff
                      name: Spot Lights
                      icon: hue:bulb-group-spot
                      template: light_button
                    - type: custom:button-card
                      entity: light.chandeleir_bedroom_3_ff
                      name: Chandelier
                      icon: hue:recessed-ceiling
                      template: light_button
                    - type: custom:button-card
                      entity: light.indirect_lights_bedroom_3_ff
                      name: Indirect Lights
                      icon: hue:lightstrip
                      template: light_button
                    - type: custom:button-card
                      entity: light.pendant_bedroom_3_ff
                      name: Pendant
                      icon: hue:wall-econic-lantern-base
                      template: light_button
                    - type: custom:button-card
                      entity: light.table_lamp_bedroom_3_ff
                      name: Table Lamp
                      icon: hue:floor-shade
                      template: light_button
                    - type: custom:button-card
                      entity: light.balcony_bedroom_3_ff
                      name: Balcony
                      icon: hue:pendant-muscari
                      template: light_button
                shutter:
                  type: custom:layout-card
                  layout_type: grid
                  layout:
                  cards:
                    - type: custom:layout-card
                      layout_type: grid
                      layout: 
                          grid-template-columns: 100%
                      cards:
                        - type: custom:shutter-card
                          entities:
                            - entity: cover.bedroom_3_covers
                              name: Bedroom 3 Covers
                          buttons_position: left
                          title_position: top
        
                          style: |
                            ha-card {
                            border-radius: 0px;
                            background: rgba(0,0,0,0);
                            box-shadow: none;
                            }
                        - type: custom:layout-card
                          layout_type: grid
                          layout: 
                              grid-template-columns: repeat(auto-fill, minmax(230px, auto))
                          cards:
                            - type: custom:mushroom-cover-card
                              entity: cover.bedroom_3_shutter_ff
                              # icon: mdi:curtains
                              show_buttons_control: true
                              show_position_control: true
                              name: Shutter
                              style: &mushroom_cover | 
                                  ha-card {
                                    background-color: transparent;
                                    --rgb-orange: 255,255,255;
                                    --rgb-state-cover: var(--mush-rgb-state-cover, var(--rgb-orange));
                                  }
                            - type: custom:mushroom-cover-card
                              entity: cover.bedroom_3_curtain_ff
                              icon: mdi:curtains
                              show_buttons_control: true
                              show_position_control: true
                              name: Curtain
                              style: *mushroom_cover 
                ac:
                  type: custom:layout-card
                  layout_type: grid
                  layout:
                        grid-template-columns: 100%
                  cards:
                    # - content: |
                    #     # Bar & Reception Areas AC
                    #   type: markdown
                    #   style:
                    #     .: |
                    #       ha-card {
                    #         background-color: rgba(0,0,0,0);
                    #         box-shadow: none;
                    #       }
                    #     ha-markdown:
                    #        |
                    #         h1 {
                    #           font-size: 20px;
                    #           text-align: left;
                    #           font-family: "Raleway", sans-serif;
                    #         }
                    - type: custom:layout-card
                      layout_type: grid
                      layout:
                        grid-template-columns: repeat(auto-fill, minmax(280px, auto))
                      cards:
                          - !include
                            - /config/lovelace/Climate.yaml
                            - climate_name: Bedroom 3 Ac 
                              climate_entity: climate.bedroom_3_ac
                              fan_entity: light.bedroom_3_ac_fan_speed

                          - !include  
                            - /config/lovelace/Heater_Climate.yaml
                            - heater_name: Bedroom 3 Heater
                              heater_entity: switch.bedroom_3_heater_ff
                              timer_entity: timer.bedroom_3_heater_ff
                              toggle_switch_entity: input_boolean.bedroom_3_heater_ff
                              counter_entity: climate.bedroom_3_heater_ff
                                  
                more:
                          type: custom:layout-card
                          layout_type: grid
                          layout:
                            grid-template-columns: 100%
        
                            grid-template-areas: |
                              "scene"
                              "alarm"
                          cards:
                            - type: custom:layout-card
                              layout_type: grid
                              view_layout:
                                grid-area: scene
        
                              layout:
                                grid-template-columns: repeat(auto-fill, minmax(150px, auto))
                              cards:
                            - type: custom:layout-card
                              layout_type: grid
                              view_layout:
                                grid-area: alarm
                                place-items: center
                              layout:
                                grid-template-columns: 300px 0px 0px
                                grid-template-areas: |
                                  "time settime auto"
                              cards:
                                - type: custom:time-picker-card
                                  view_layout:
                                    grid-area: time
                                  entity: input_datetime.bedroom_3_alarm
                                  hour_mode: 12
                                  hour_step: 1
                                  minute_step: 5
                                  second_step: 5
                                  layout:
                                    align_controls: left
                                    name: header
                                  hide:
                                    seconds: true
                                  link_values: false
                                  style: |
                                    ha-card {
                                      border-radius: 3%;
                                      background-color: #06090F;
                                      width: 300px;
                                      postion: relative;
                                    }
        
                                    :host {
                                      --time-picker-elements-background-color: #6F6F6F;
                                      --time-picker-border-radius: 0%;
                                      --time-picker-text-color: white;
                                    }
                                  name: ""
                                - type: custom:button-card
                                  view_layout:
                                    grid-area: settime
                                  entity: automation.bedroom_3_alarm
                                  template: alarm_style
                                - !include popup/set-alarm-label.yaml


        view_layout:
          grid-area: list
      - type: custom:button-card
        show_entity_picture: true
        entity_picture: /local/logo.png
        view_layout:
          grid-area: footer
''') as Map;
  print(json.encode(parse(doc['pages'][0]['cards'])));
}
