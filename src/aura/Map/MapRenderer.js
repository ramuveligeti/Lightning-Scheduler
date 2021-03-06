({
    rerender: function (component) {

        var nodes = this.superRerender();

        // If the Leaflet library is not yet loaded, we can't draw the map: return
        if (!L) {
            return nodes;
        }

        // Draw the map if it hasn't been drawn yet
	    if (!component.map) {
            var mapElement = component.find("map").getElement();
            component.map = L.map(mapElement, {zoomControl: true}).setView([42.356045, -71.085650], 13);
            component.map.scrollWheelZoom.disable();
            L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}', {attribution: 'Tiles © Esri'}).addTo(component.map);
	    }

		var location = component.get('v.location');

        if (!location) {
            return nodes;
        }

        var latLng = [location.Location__Latitude__s, location.Location__Longitude__s];
        if (component.marker) {
            component.marker.setLatLng(latLng);
        } else {
            component.marker = L.marker(latLng);
            component.marker.addTo(component.map);
        }
        component.map.setView(latLng);

        return nodes;

    }
})