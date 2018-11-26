Vue
===

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
caller of ``dispatch``.

Actions can return Promises (via dispatch).

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
