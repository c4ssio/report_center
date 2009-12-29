// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//allows proper-casing for strings
String.prototype.toProperCase = function()
{
  return this.toLowerCase().replace(/^(.)|\s(.)/g, function($1) { return $1.toUpperCase(); });
}