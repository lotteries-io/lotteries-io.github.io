---
layout: page
title: Pool Status
---

# Pool Status

Defines the status of a [Participation Pool](../concepts/participation-pool) regarding the acceptance of tickets.

One of:

* `created`. The pool exists, but no orders may be placed.
* `sales-open`. Orders may be placed by retailers.
* `sales-closed`. Orders may no longer be placed by retailers. Orders that are still `in-process` may still be `accepted`.
* `finalising`. Orders may no longer be placed. Any orders that are not yet accepted will be placed in status `failed`.
* `finalised`. Pool is in a final state with all bets known.
* `winners-computed`. Bets have been allocated to winning classes.
* `winnings-assigned`. Bets with winning classes have had winning allocated to them.
