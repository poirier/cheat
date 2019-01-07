Vue
===

Reactivity
----------

The following applies to the store's state, anything in a component's
*data*, and other things that get pulled into the reactivity system.

When an object is added to Vue's reactivity system, Vue replaces all
its properties with getters and setters under the covers, so that if
you fetch the value of a property, or assign a new value to it, Vue
is aware and can react. (`<https://vuejs.org/v2/guide/reactivity.html>`_)

However, for technical reasons, Vue cannot detect when a property is
added to or removed from an object.
(`<https://vuejs.org/v2/guide/reactivity.html#Change-Detection-Caveats>`_)

**The implications are:**

* When updating the store, it's fine to assign a new value to a property
  of the *state*.
* When updating component data, it's fine to assign a new value to a
  property of the component.
* Don't try to use Object.assign or equivalent to update properties of
  objects in-place in the store????  It doesn't seem to work.

Vuex (the store)
----------------

Getters
.......

`Getters doc <https://vuex.vuejs.org/guide/getters.html>`_

Getters provide computed values based on the state. Their
results are cached until the state they depend on changes.

Getters are accessed as *properties* not *methods*.

They are passed as a second arg an object with all the store's
getters, in case they want to use them.

::

    const store = new Vuex.Store({
        ...
        getters: {
            totalCost: (state, othergetters) => {
               return some_computation_on_state
            }

    // component...

    computed: {
        the_total_cost () {
            return store.getters.totalCost    // No parens, not called like a method
        }
    }

Mutations
.........

`Mutations doc <https://vuex.vuejs.org/guide/mutations.html>`_

Mutations *must be synchronous*.

They cannot be called. They must be invoked using ``commit``.

They receive a state and optional arguments, and can change
the state.

When the state changes, other Vue components observing the
state will update automatically.

Any value returned by a mutation is *not* passed back to
the caller of ``commit``.

Actions
.......

`Actions doc <https://vuex.vuejs.org/guide/actions.html>`_

Actions can contain asynchronous code.  They receive a ``context`` object
that has methods like ``commit`` and properties like
``state`` and ``getters``.

Actions cannot be called. They must be invoked using ``dispatch``.

Any value returned by an action is passed back to the
caller of ``dispatch``, by way of resolving the promise
that dispatch returns to that value.

Dispatching actions always returns Promises.

Example::

    const store = new Vuex.Store({
      state: {
        count: 0
      },
      mutations: {
        increment (state) {
          state.count++
        }
      },
      actions: {
        increment (context) {
            context.commit('increment')
        },
        checkout ({ commit, state }, products) {
            // save the items currently in the cart
            const savedCartItems = [...state.cart.added]
            // send out checkout request, and optimistically
            // clear the cart
            commit(types.CHECKOUT_REQUEST)
            // the shop API accepts a success callback and a failure callback
            shop.buyProducts(
              products,
              // handle success
              () => commit(types.CHECKOUT_SUCCESS),
              // handle failure
              () => commit(types.CHECKOUT_FAILURE, savedCartItems)
            )
        },
        async actionA ({ commit }) {
            commit('gotData', await getData())
        },
        async actionB ({ dispatch, commit }) {
            await dispatch('actionA') // wait for `actionA` to finish
            commit('gotOtherData', await getOtherData())
        }
      }
    })

Custom components implementing v-model
--------------------------------------

Vue handles the heavy lifting when a component is
included somewhere with a v-model attribute. All your
component needs to do is accept a "value" property,
and emit an "input" event when the value changes,
with the new value.

Possibly surprising things in Vue
=================================

The Vue documentation tells you how almost everything in Vue works,
but you really need to know more than that to use Vue. I like
the analogy that knowing how to drive nails and saw boards
doesn't enable you to build a house, especially not a house
that won't fall down.

Here are some things I've discovered through experience, or
that were mentioned in the documentation but I've found to be
more important than I would have guessed.

* You can start your ``.vue`` file with a big multiline ``<!-- ...  -->``
  comment to document it.

Templates
---------

* A component must end up rendering either zero or one HTML
  element. It may, of course, have lots of stuff nested inside.
  The real surprise to me was that it can render to no
  element at all.

* You can use both ``:class`` and ``class`` on the same element.
  The resulting classes will be merged.

* When using 'v-if', 'v-else', 'v-else-if' in templates, give each
  element using them a unique key, just as if they were using
  'v-for'.

* "control-flow" features like 'v-if' and 'v-for' can only be used
  as attributes on HTML elements. But if you really don't want an
  HTML element there, you can put them on the pseudo-element
  ``<template>``.

* ``v-model`` should never refer directly to things in the store, because
  it'll try to change values without going through mutations.
  Using a computed property with a setter handles this nicely.

.. note:: Wouldn't it be nice if Vue did "the right thing" in this case?

* ``v-model`` can refer to properties inside a computed property
  (e.g. ``v-model="prop1.subprop"``) where ``prop`` is a computed
  property.

.. warning:: But I haven't tested that the setter gets invoked when prop.subprop is changed, or does v-model just update the object in place. I'd guess the latter.

* If you need to access something from a template that isn't already
  part of the component's data or methods, just import it and stick
  it into ``.data``.  E.g.::

      import { utilMethod } from '@/utils'
      export default {
        data () {
          return {
            a: 1,
            utilMethod
          }
        }
      }

  Or maybe methods would be better stuck into ``methods``?

* When using ``v-for``, if there's anything in the list you're going
  to iterate over that you don't want to include, then use a computed
  property, or a method, to filter the list down to just the items you do
  want to include, then iterate over that using ``v-for``.

Component code
--------------

* You can use `ref <https://vuejs.org/v2/api/#ref>`_ to get access
  in component code to the DOM.

* Give every component a ``name``. It'll make output in the
  browser console more useful, and is required when nesting
  components recursively.

* Properties
  are a `one-way flow <https://vuejs.org/v2/guide/components-props.html#One-Way-Data-Flow>`_
  of information into components. Never change the value of a prop
  from inside the component it was passed to, because it's too easy
  to forget that the value does *not* get passed back. If you find yourself
  wanting to do that, find a way to tell the parent so they can
  change the value being passed in as the prop.

  To get information back out of a component, you can use:

  * events
  * the store
  * ``v-model``

* Not everything is reactive. Here are some things that are "reactive"
  (one way or another):

  * .computed
  * .data
  * .props
  * .watch

  In particular, just because you access some data from the store,
  doesn't mean changes to that data in the store will necessarily
  result in Vue doing anything.

  If you need something to be reactive, access it in a computed
  method, or put it in .data, or pass it as props, or watch it.

.. attention::
  Does accessing anything from inside a computed property
  result in Vue watching that thing for changes? Or does that only
  happen if the thing was already reactive?

* Computed properties are cached as long as the data they accessed
  while generating their value has not changed, so feel free to
  refer to them a lot.

* Computed properties can have
  `getters and setters <https://vuejs.org/v2/guide/computed.html#Computed-Setter>`_
  which makes them a *lot* more useful.  A common pattern is
  for get() to get a value from the store and set() to update
  the store.

* ``v-model`` and a computed property work very well together.

* The arguments to a watch method are ``(newvalue, oldvalue)`` and
  not the other way around.

The store
---------

* Dispatching an action always returns a promise, whether you wrote code in the
  action method to do that or not. Of course, if you do return a
  promise, it'll be returned to the caller. But this does mean
  that every time you dispatch an action, you can (and must) assume it's
  going to run asynchronously and code appropriately.

* It's often a good idea to resist putting things into the store
  unless you have to. It is, essentially, a big set of global
  variables.  Some reasons I think you might reasonably put things
  into the store:

  * you'd otherwise need to pass data as properties down into
    multiply nested components
  * you need to share data among components that are only
    distantly related

  Note that you can still model access to data in your backend by
  using store actions, but even then, you don't necessarily have to save a
  copy of the data in the store.
