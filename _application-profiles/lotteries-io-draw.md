---
layout: page
title: Lotteries.io Draws
---

# Lotteries.io Draws

## Named Draw Series

A [Draw Series](../concepts/draw-series) is a named series of [Draws](../concepts/draw). The [Canonical Name](../properties/canonical-name) of a [Draw Series](../concepts/draw-series) may be the same as a [Gaming Product](../concepts/gaming-product) based around it - but *they are not the same thing*.

A resource representing a [Draw Series](../concepts/draw-series) should include:

* [draw-organiser](../link-relationships/draw-organiser)
* [current-draw-scheme](../link-relationships/draw-scheme)
* [canonical-name](../properties/canonical-name)
* [draw-schedule](../properties/draw-schedule),optional. If present, must be described in the operator application profile so that it can be evaluated correctly by client code
* [draws](../link-relationships/draws) to discover the available draws

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
       "href": "http://www.operator.com/draw-series/series1/scheme1"
     },
     "lo:draws" : {
     	"href": "http://www.operator.com/draw-series/series1/draws{?fromDate,toDate}",
     	"templated": true
     },
     "self": {
       "href": "http://www.operator.com/draw-series/series1"
     }
   },
   "canonical-name": "series1"
}

{% endhighlight %}

### Draw Schedule

[Draw Schedules](../concepts/draw-schedule) define the schedule for [Draws](../concepts/draw) in a [Draw Series](../concepts/draw-series) - in other words, a method of determining when future [Draws](../concepts/draw) will take place so that [Participation Pools](../concepts/participation-pool) can be created and opened in a timely fashion.

The draw schedule may change over time in accordance with the needs of the [Draw Organiser](../concepts/draw-organiser). The exact form **must** be defined by the operator application profile so that the expressions can be interpreted.

Representation forms such as cron expressions or iCalendar (via [jCal](https://tools.ietf.org/html/rfc7265) are conceivable).

## Navigating the list of draws

A resource that describes part or all of a list of draws available for a [Draw Series](../concepts/draw-series) lists these sorted on draw time, earlier draws being listed before later ones. The resources may be paged, in which case the standard `next` and `prev` link relationships from the [IANA Assigned LInk Relationships](http://www.iana.org/assignments/link-relations/link-relations.xhtml) are used to move within the collections.

Such a resource is essentially a list of [draw](../link-relationships/draw) links to resources describing individual draws. We enhance the links with the [draw-time](../properties/draw-time) property for better ease of use. For example:

{% highlight json%}
{
   "_links":{
      "curies":[
         {
            "name":"lo",
            "href":"http://www.lotteries.io/link-relationships/{link-relationship}",
            "templated":true
         }
      ],
      "lo:draw":[
         {
            "href":"http://www.operator.com/draw-series/series1/draws/45678",
            "draw-time":"2015-02-23T12:00:00Z"
         },
         {
            "href":"http://www.operator.com/draw-series/series1/draws/45677",
            "draw-time":"2015-02-22T125:00:00Z"
         }
      ],
      "next":{
         "href":"http://www.operator.com/draw-series/series1/draws?page=3"
      },
      "prev":{
         "href":"http://www.operator.com/draw-series/series1/draws?page=1"
      },
      "lo:draw-series":{
         "href":"http://www.operator.com/draw-series/series1"
      },
      "self":{
         "href":"http://www.operator.com/draw-series/series1/draws?page=2"
      }
   },
}

{% endhighlight %}

## Discovering information about Individual Draws

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
