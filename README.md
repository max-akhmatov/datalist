DataList is a simple pattern for managing a list of items written in swift.

- [What is it](#what-is-it)
- [Requirements](#requirements)
- [Example 1](#example-1)

## What is it

When creating amazing apps in swift, usually we need to display many data lists (items in a cart, list of favourite addresses, users registered for a conference etc.). In the most cases, users can make actions with things like searching, filtering and ordering. You can say that it is just enough to create a simple array of objects and to make all operations with it, no complexity at all! Yes and sometimes it is reasonable, but is this always useful for the app architecture? Probably, no. 
Data list is an abstract class that aims to help organise operations with data lists in a separate class. It provides the mechanism for applying filters and sorting.

## Requirements

- iOS 9.1+ / macOS 10.10+
- Xcode 9.1+
- Swift 4.0.1+

## Example 1

Let's assume, we need to display items in cart for e-shop. The user can sort items by the cost and show only the goods that are available with discount. So, what do we have here? 

First of all, it is the **ShoppingCart** object where the items are stored (this is our Data List). We also have a **ShoppingItem** object that describes a thing the user wants to buy.

Define the **ShoppingItem**
```swift
struct ShoppingItem {
    var name: String

    var cost: Float
    var discount: Float?
}
```

Define the **ShoppingCart**
```swift
class ShoppingCart: DataList<ShoppingItem> {

    func applySortingByCost() {
        addSortDescriptor { (collection: [ShoppingItem]) -> ([ShoppingItem]) in
            return collection.sorted(by: {$0.cost > $1.cost})
        }
    }

    func applyFilterByDiscountAvailable() {
        addFilter { (collection: [ShoppingItem]) -> ([ShoppingItem]) in
            return self.filter({$0.discount != nil})
        }
    }
}
```

Usage
```swift
let objects: [ShoppingItem] = // get objects (from the server, from DB etc.)

// initialize the cart
let shoppingCart = ShoppingCart(objects)

// apply the filter and the sorting
shoppingCart.applySortingByCost()
shoppingCart.applyFilterByDiscountAvailable()

// use the cart
for item in shoppingCart {
    // make whenether you want - here is the only items after filtering and with the desired sorting
}
```


