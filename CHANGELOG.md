## 0.12.1
[2023-07-20]
#### Fixed
- change overlay color to transparent

## 0.12.0
[2022-08-28]
#### Added
- Add OnRouteNotRegistered callback

## 0.11.0
[2022-08-13]
#### Added
- The property name from MicroAppEvent becomes optional
#### Chore
- update readme

## 0.10.0
[2022-07-21]

#### Added
- Add GenericMicroAppEventController in order to enable webview controllers

## 0.9.0
[2022-07-10]

#### Break
- `registerEventHandler` method is available by mixins `HandlerRegisterMixin` and `HandlerRegisterStateMixin`
- MicroAppEventHandler is no required to micro apps
- Micro apps requires a name

#### Added
- Add micro board - A page to show all micro applications, routes and event handlers

#### Chore
- Supports both Flutter version 2 and version 3

## 0.8.0
[2022-05-22]

#### Break
- Using Map as default data transfer object, instead string

#### Fix
- Enable/disable native requets in navigation events

#### Added
- Parses event data from native platform
- Add optional timeout parameter, but still can use timeout in the old way as well

## 0.7.0
[2022-05-03]
#### Break
- WidgetPageBuilder (arguments:dynamic) parameter becomes (settings:RouteSettings)
#### Added
- Separation of native events enablers
- Make optional the widgetbuilder channels

## 0.6.0
[2022-04-27]
#### Break
- PageBuilder `function` became `class`
#### Added
- Add transition animation per MicroPage
- Add hasRoute method to NavigatorInstance


## 0.5.0
[2022-02-20]
#### Added
- Add event handler list to mixin
- close navigator when firstpage pops
- add transitions for navigation
- fix lint warnings
- add navigator widget
- add maNav to BuildContext extension
#### Break
- change route to pageBuilder
- getFragment becomes getPageBuilder


## 0.4.0
[2022-02-12]
#### Added
``` diff
+ add HandlerRegisterMixin to deal with BuildContext, and example
+ add example how to use overlay(float page)
+ add example how to emit and receive event, in order to change colors on other micro app component
+ add example how to complete an event, asynchronously
```

#### Break
```diff
- break changing:  MicroApp.routes becomes MicroApp.pageBuilders
```
  
## 0.3.0
[2022-02-06]
#### Added
```diff
+ add distinct property to handlers
```

## 0.2.0
[2022-02-05]
#### Added
```diff
+ improved channel filter performance
+ event filtering by type
+ new widget builder (MicroAppWidgetBuilder)
+ bug fixes
+ refactoring
```

## 0.1.0
[2022-01-30]
* initial release.


