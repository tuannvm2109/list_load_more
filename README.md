A beautiful ListLoadMore easy to use and customize.

###### List Load More
![DEMO](https://github.com/tuannvm2109/list_load_more/blob/master/assets/list_load_more.gif)

## Usage

###### Simple implementation:

```dart
        final GlobalKey<ListLoadMoreState> _key = GlobalKey();
```

```dart
        ListLoadMore<Employee>(
            key: _key
            status: ListLoadMoreStatus.none,
            total: totalItem,
            itemBuilder: (item, index) => _employeeWidget(item),
            onLoadMore: (int currentTotal) async {
              // call your API load more here with currentTotal is total item we have
            },
            onRefresh: () async {
              // call API refresh here
            },
        )
```

###### Then you can add your new items to ListLoadMore:

```dart
       _key.currentState?.addData(yourNewItemList);
```
###### Or you can add single, remove single item:

```dart
       _key.currentState?.addItem(item: yourItem, index: 0);
       _key.currentState?.removeItem(index: 0);
```

###### You can focus to specific index:

```dart
       _key.currentState?.focusToIndex(index);
```

## License

```
Copyright (c) 2021 Tuannvm

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
