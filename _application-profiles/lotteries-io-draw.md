---
layout: page
title: Lotteries.io Draws
---

# Lotteries.io Draws

## Finding out about Draws

Draw resources give information about a [Draw](../concepts/draw) - and, quite intentionally, no data about the [Participation Pools](../concepts/participation-pool) that are organised around their outcome by [Operators](../concepts/operator) in the form of [Gaming Products](../concepts/gaming-product).

Note that this means that, in theory at least, an arbitrary number of [Gaming Products](../concepts/gaming-product) can be defined by an arbitrary number of [Operators](../concepts/operator) around the outcome of a single [Draw Series](../concepts/draw-series).

A resource describing a draw should include at least:

* [draw-organiser](../link-relationships/draw-organiser)
* [draw-scheme](../link-relationships/draw-scheme)
* [draw-series](../link-relationships/draw-series)
* [draw-time](../properties/draw-time), the scheduled time and date of the draw event
* [draw-outcome](../properties/draw-outcome) the draw outcome in the form described by the draw scheme. The property should only be added to the representation when the outcome is known.

For example:

{% highlight json%}
{
  "_links": {
    "curies": [
      {
        "name": "lo",
	      "href": "http://www.lotteries.io/link-relationships/{link-relationship}",
	      "templated": true
      }
     ],
     "lo:draw-organiser": {
        "href": "http://www.operator.com/organisations/self"
     },
     "lo:draw-scheme": {
       "href": "http://www.operator.com/draws/series1/scheme1"
     },
     "lo:draw-series": {
        "href": "http://www.operator.com/draws/series1"
      }
     "self": {
        "href": "http://www.operator.com/draws/series1/123456"
     }
   },
   "draw-time": "2015-02-26T18:00:00Z",
   "draw-outcome": {
     "numbers": [1, 2, 3, 4, 5, 6]
   }
}

{% endhighlight %}

## Named Draw Series

A [Draw Series](../concepts/draw-series) is a named series of [Draws](../concepts/draw). The [Canonical Name](../properties/canonical-name) of a [Draw Series](../concepts/draw-series) may be the same as a [Gaming Product](../concepts/gaming-product) based around it - but *they are not the same thing*.

A resource representing a [Draw Series](../concepts/draw-series) should include:

* [draw-organiser](../link-relationships/draw-organiser)
* [current-draw-scheme](../link-relationships/draw-scheme)
* one or more [draw-schedule](../link-relationships/draw-schedule) links
* [canonical-name](../properties/canonical-name)

For example:

{% highlight json%}
{
  "_links": {
    "curies": [
      {
        "name": "lo",
	      "href": "http://www.lotteries.io/link-relationships/{link-relationship}",
	      "templated": true
      }
     ],
     "lo:draw-organiser": {
        "href": "http://www.operator.com/organisations/self"
     },
     "lo:current-draw-scheme": {
       "href": "http://www.operator.com/draws/series1/scheme1"
     },
     "lo:draw-schedule": [{
          "href": "http://www.operator.com/draws/series1/schedule1"
      },{
          "href": "http://www.operator.com/draws/series1/schedule2",
          "name": "current"
      }],
     "self": {
 	      "href": "http://www.operator.com/draws/series1"
     }
   },
   "canonical-name": "series1"
}

{% endhighlight %}
