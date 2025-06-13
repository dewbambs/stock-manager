## Description

- need to create a sample stock flutter application.
- The stock application is expected to have a single page where stocks will be visible.
- We will not be implementing any abstraction layer and keep the applciation tightly coupled as it's a sample stock application.
- We will be using visibility package in ListView flutter to show/hide the stock item.

## Application Layers

### data source mock websocket
1. We will mock a simple stock in memory data which will update the stock every 5 seconds.
2. This layer will give a mock websocket connection which will update the stock in memory data.

### Data layer of application

1. We will fetch the stock data one time to fetch all the stocks that should shown to the user.
2. We will be maintaining a stream to provide stock to the inner layer i.e. the repository. 
3. On first fetch we will provide the complete stock list to the stream.
4. On every update from the websocket connection we will update the stock in the stream.

### Repository layer
1. This layer will be responsible for fetching the data from the data source and again provide it to the bloc.
2. We will not maintain stream in this layer rather we will be receiving a callback from bloc which will be used to update the data. example given below

```dart
StreamSubscription<NudgeItem?> subscribeToQuickAccessUpsertStream({
    required NudgeItem? Function(dynamic) convert,
    required Function(NudgeItem?) callback,
  }) {
    return _upsertController.stream.map(convert).listen(callback);
  }
```
3. Other than this we will maintain a visibility set here which will be used to provide information to the data layer which will provide this information to mock websocket. So that we only receive the data which is visible to the user.
4. There should be methods to insert/update/remove the stock from the visibility set.
5. Whenever the user scrolls the list we will update the visibility set. This will be triggered via block/ui layer.

### Presentation Layer
#### Bloc layer
1. Implement a single bloc without using Either syntax or freezed package.
2. Bloc will create a subscription using the method exposed by repository by giving a callback function. Whenever we receive a update on this callback we will update the state of the UI.
3. We will use bloc to update the visibility set. Whenever the user scrolls the list we will update the visibility set. This will be triggered via bloc.
4. First request needs to be to fetch the complete stock list. This will be triggered via bloc and update the state of the UI.
5. We will use bloc to fetch the stock data. This will be triggered via bloc and update the state of the UI.

#### UI Layer
1. We will be using bloc to fetch the stock data. This will be triggered via bloc and update the state of the UI.
2. We will be using bloc to update the visibility set. Whenever the user scrolls the list we will update the visibility set. This will be triggered via bloc.
3. Package to be used
    1. infinite_scroll_pagination for managing and detective offset at which the user is.
    2. visibility_detector for checking the visibility of the item.
    3. Bloc to manage the state.
4. The app will show simple ListView.Builder to show the stock list.
5. Use selector from bloc. So that we only update the state when needed stock is updated
