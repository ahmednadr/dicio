import 'package:yaml/yaml.dart';
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
    tree.putIfAbsent("test${number++}", () => handleResult);
  }
  return tree;
}

Map handleType(element) {
  var type = element['type'];
  switch (type) {
    case "custom:swipe-card":
      return {"swipe card": parse(element['cards'])};
    case "custom:layout-card":
      return {"layout": parse(element['cards'])};
    case "custom:button-card":
      return {
        "type": "button",
        "name": element['name'],
        "template": element['template'],
        "entity": element['entity'],
      };
    case "picture-glance":
      return {
        "type": "card",
        "image": element["image"],
        "actions": {
          "ontap": {"path": element['tap_action']['navigation_path']}
        }
      };
    case "custom:weather-card":
      return {"weather": element['entity']};
  }

  return {};
}

Map handleContent(element) {
  return {"text": element['content']};
}

void main() {
  var doc = loadYaml('''
# lovelace_gen
button_card_templates: !include button_card_templates.yaml
title: Palm

views:
  - type: custom:grid-layout
    path: default_view
    title: Home
    layout:
      grid-auto-columns: 100%
    icon: mdi:home
    badges: []
    cards:
      - type: custom:layout-card
        layout_type: grid
        layout:
          grid-template-columns: 100%
          grid-template-areas: |
            "extras "
            "weather "
        cards:
          - !include popup/menu-all-devices-popup.yaml
          - type: custom:weather-card
            entity: weather.home
            number_of_forecasts: "5"
            details: true
            forecast: false
            hourly_forecast: true
            name: Weather
            style:
              .: |
                ha-card {
                  background-color: rgba(0,0,0,0);
                  box-shadow:none;
                }
            view_layout:
              grid-area: weather
      - content: |
          # Ground Floor
        type: markdown
        style:
          .: |
            ha-card {
               #width: 50px;
               #height: 10px;
               background-color: rgba(0,0,0,0);
               border-top-left-radius: 20px;
               border-top-right-radius: 20px;
                box-shadow: none;
            }
          ha-markdown:
            : |
              h1 {
                font-size: 20px;
               # font-weight: bold;
                text-align: left;
                letter-spacing: '-0.01em';
                font-family: "Raleway", sans-serif;
              }
      - type: custom:swipe-card
        start_card: 3
        card_width: 25em
        parameters:
          centeredSlides: true
          centeredSlidesBounds: true
          slidesPerView: auto
          spaceBetween: 10
          pagination:
            type: custom
          navigation: null
          keyboard:
            enabled: true
            onlyInViewport: true
          grabCursor: true
        cards:
          - aspect_ratio: 0%
            entities: []
            image: /local/iconHA/entrance1.jpg
            tap_action:
              action: navigate
              navigation_path: /lovelace/ground-Entrance
            title: Entrance
            type: picture-glance
          - aspect_ratio: 0%
            entities: []
            image: /local/iconHA/reception.jpg
            tap_action:
              action: navigate
              navigation_path: /lovelace/ground-Reception
            title: Reception
            type: picture-glance
          - aspect_ratio: 0%
            entities: []
            image: /local/Home-Images/Dinning2.png
            tap_action:
              action: navigate
              navigation_path: /lovelace/ground-Kitchen
            title: Dining
            type: picture-glance
      - type: custom:layout-card
        layout_type: grid
        layout:
          grid-template-columns: repeat(auto-fill, minmax(115px, auto))
        cards:
          - type: custom:button-card
            entity: light.spot_lights_bedroom_3_ff
            name: Spot Lights
            icon: hue:bulb-group-spot
            template: light_button
      - content: |
          # First Floor
        type: markdown
        style:
          .: |
            ha-card {
               #width: 50px;
               #height: 10px;
               background-color: rgba(0,0,0,0);
               border-top-left-radius: 20px;
               border-top-right-radius: 20px;
               box-shadow: none;
            }
          ha-markdown:
            : |
              h1 {
                font-size: 20px;
               # font-weight: bold;
                text-align: left;
                letter-spacing: '-0.01em';
                font-family: "Raleway", sans-serif;
              }
      - type: custom:swipe-card
        card_width: 25em

        start_card: 3
        parameters:
          centeredSlides: true
          slidesPerView: auto
          spaceBetween: 10
          pagination:
            type: custom
          navigation: null
          keyboard:
            enabled: true
            onlyInViewport: true
          grabCursor: true
        cards:
          - aspect_ratio: 0%
            entities: []
            image: /local/Home-Images/Stairs1.png
            tap_action:
              action: navigate
              navigation_path: /lovelace/stairs
            title: Stairs
            type: picture-glance
          - aspect_ratio: 0%
            entities: []
            image: /local/iconHA/MasterRoom1.jpg
            tap_action:
              action: navigate
              navigation_path: /lovelace/first-masterroom
            title: Master Room
            type: picture-glance
          - aspect_ratio: 0%
            entities: []
            image: /local/Home-Images/Family.jpg
            tap_action:
              action: navigate
              navigation_path: /lovelace/first-Bedroom_1
            title: Living&Lobby
            type: picture-glance
      - content: |
          # Outdoor & Security
        type: markdown
        style:
          .: |
            ha-card {
               #width: 50px;
               #height: 10px;
               background-color: rgba(0,0,0,0);
               border-top-left-radius: 20px;
               border-top-right-radius: 20px;
                box-shadow: none;
            }
          ha-markdown:
            : |
              h1 {
                font-size: 20px;
                font-family: "Raleway", sans-serif;
               # font-weight: bold;
                text-align: left;
                letter-spacing: '-0.01em';
              }
      - type: custom:swipe-card
        card_width: 25em

        start_card: 3
        parameters:
          centeredSlides: true
          slidesPerView: auto
          spaceBetween: 10

          navigation: null
          keyboard:
            enabled: true
            onlyInViewport: true
          grabCursor: true
        cards:


          - aspect_ratio: 0%
            entities: []
            image: /local/iconHA/caneras (1).webp
            tap_action:
              action: navigate
              navigation_path: /lovelace/security
            title: Security
            type: picture-glance
          - aspect_ratio: 0%
            entities: []
            image: /local/Home-Images/Gate.png
            tap_action:
              action: navigate
              navigation_path: /lovelace/gates
            title: Gates
            type: picture-glance
          - aspect_ratio: 0%
            entities: []
            image: /local/iconHA/Landscape.jpg
            tap_action:
              action: navigate
              navigation_path: /lovelace/ground-Outdoor
            title: Landscape
            type: picture-glance
      - type: custom:button-card

        show_entity_picture: true
        entity_picture: /local/logo.png
        styles: &Footer_Style
          card:
            - width: 100%
            - background-color: transparent
            - box-shadow: none
            - justify-content: center
            - justify-self: end
            - '--mdc-ripple-press-opacity': 0
          entity_picture:
            - width: 50%
            - margin: 0px
          img_cell:
            - justify-content: center
        # view_layout:
        #   grid-area: footer
        
 

''') as Map;
  print(json.encode(parse(doc['views'][0]['cards'])));
}
