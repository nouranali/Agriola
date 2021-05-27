var gfc2020 = ee.Image("UMD/hansen/global_forest_change_2020_v1_8")
var gsw = ee.Image("JRC/GSW1_0/GlobalSurfaceWater");
var delta=ee.Geometry.Polygon(
        [[[30.469643638427883, 31.450819992635658],
          [30.216958091552883, 31.25849086743306],
          [29.991738364990383, 31.272577062520014],
          [29.931313560302883, 31.202125067715457],
          [29.832436607177883, 31.070474241780822],
          [29.491860435302883, 30.90565409363286],
          [29.294106529052883, 30.811343444159508],
          [29.953286216552883, 30.598805898627774],
          [31.238686607177883, 30.06304490537854],
          [32.29337410717788, 31.079883930397045],
          [31.930825279052883, 31.488301723179053],
          [31.392495200927883, 31.50235350217253],
          [30.958535239990383, 31.57726064620009]]]);
var lossImage = gfc2020.select(['loss']);
var lossAreaImage = lossImage.multiply(ee.Image.pixelArea());
var lossYear = gfc2020.select(['lossyear']);
var occurrence = gsw.select('occurrence');



Map.setCenter(31.1225, 30.2436, 11);


//selecting the absolute occurrence change intensity layer 
var change = gsw.select("change_abs");
var VIS_CHANGE = {
    min:-50,
    max:50,
    palette: ['red', 'black', 'limegreen']
};
// Map.addLayer({
//   eeObject: change,
//   visParams: VIS_CHANGE,
//   name: 'occurrence change intensity',
//     shown:0
// });

//////////////////////////////////////
//////animating part//////////////////
/////////////////////////////////////

var col = ee.ImageCollection('JRC/GSW1_1/YearlyHistory').map(function(img) {
var year = img.date().get('year');
var yearImg = img.gte(2).multiply(year);
var despeckle = yearImg.connectedPixelCount(15, true).eq(15);
return yearImg.updateMask(despeckle).selfMask().set('year', year);
});

//function that reverse frame sequence once the end is reached

function appendReverse(col) {
return col.merge(col.sort('year', false));
}

var bgColor = '000000'; // Assign white to background pixels.
var riverColor = '0D0887'; // Assign blue to river pixels.
var annualCol = col.map(function(img) {
return img.unmask(0)
.visualize({min: 0, max: 1, palette: [bgColor, riverColor]})
.set('year', img.get('year'));
});
var basicAnimation = appendReverse(annualCol);
 

var bgImg = ee.Image(1).visualize({palette: bgColor});
var yearSeq = ee.List.sequence(1984, 2018);


/////////////creating interactive buttons////////
var drawingTools = Map.drawingTools();
// Hide the default drawing
drawingTools.setShown(false);

//clear all existing geometries 
while (drawingTools.layers().length() > 0) {
  var layer = drawingTools.layers().get(0);
  drawingTools.layers().remove(layer);
}



var dummyGeometry =
    ui.Map.GeometryLayer({geometries: null, name: 'geometry', color: '23cba7'});

drawingTools.layers().add(dummyGeometry);


//dummy GeometryLayer with null geometry as placeholder for drawn geometries.
var dummyGeometry =
    ui.Map.GeometryLayer({geometries: null, name: 'geometry', color: '23cba7'});

drawingTools.layers().add(dummyGeometry);


//////////functions to be called when button is clicked. 
function clearGeometry() {
  var layers = drawingTools.layers();
  layers.get(0).geometries().remove(layers.get(0).geometries().get(0));
  chartPanel.style().set('shown', false)
}
function drawRectangle() {
  clearGeometry();
  drawingTools.setShape('rectangle');
  drawingTools.draw();
}
// function drawPolygon() {
//   clearGeometry();
//   drawingTools.setShape('polygon');
//   drawingTools.draw();
// }

// function drawPoint() {
//   clearGeometry();
//   drawingTools.setShape('point');
//   drawingTools.draw();
// }
function clearanimation() {
  clearGeometry();
}

///panel for charts
var chartPanel = ui.Panel({
  style:
      { position: 'bottom-right', shown: false,
        color: '000000',padding:'0',border:'0'}
});

Map.add(chartPanel);
/////////////////////



//Create key of items for dropdown
var barchart = 'Water change intensity'
var piechart = 'Water transition classes'
var fading = 'Fading history'
var cumulative= 'Cumulative history'
var ndvi='NDVI'
var losses='Losses'

//Construct Dropdown
var graphSelect = ui.Select({
  items:[barchart,piechart,fading,cumulative,ndvi,losses],
  placeholder:'Choose chart type',
  onChange: selectchart,
  style: {position:'top-right',backgroundColor :'rgba(240,240,240,0.5)'}
})

//Write a function that runs on change of Dropdown
function selectchart(){
  
   // Make the chart panel visible the first time a geometry is drawn.
  if (!chartPanel.style().get('shown')) {
    chartPanel.style().set('shown', true);
  }

  // Get the drawn geometry; it will define the reduction region.
  var aoi = drawingTools.layers().get(0).getEeObject();

  // Set the drawing mode back to null; turns drawing off.
  drawingTools.setShape(null);
  
  // get value from dropdown selection
  var graph = graphSelect.getValue(); 
  
  
  ////////////////////////////////////////
  ////////////animating part//////////////
  ////////////////////////////////////////
  var col = ee.ImageCollection('JRC/GSW1_1/YearlyHistory').map(function(img) {
  var year = img.date().get('year');
  var yearImg = img.gte(2).multiply(year);
  var despeckle = yearImg.connectedPixelCount(15, true).eq(15);
  return yearImg.updateMask(despeckle).selfMask().set('year', year);
  });
  
  //function that reverse frame sequence once the end is reached
  
  function appendReverse(col) {
  return col.merge(col.sort('year', false));
  }
  
  var bgColor = '000000'; // Assign white to background pixels.
  var riverColor = '0D0887'; // Assign blue to river pixels.
  var annualCol = col.map(function(img) {
  return img.unmask(0)
  .visualize({min: 0, max: 1, palette: [bgColor, riverColor]})
  .set('year', img.get('year'));
  });
  var basicAnimation = appendReverse(annualCol);
  
  
  var bgImg = ee.Image(1).visualize({palette: bgColor});
  var yearSeq = ee.List.sequence(1984, 2018);

  var videoArgs = {
  dimensions:
  450, // Max dimension (pixels), min dimension is proportionally scaled.
  region: aoi,
  framesPerSecond: 10
  };

  //We use "if else" statements to write instructions for drawing graphs
  if (graph == barchart){
  
  // Generate histogram object for the selected area of interest.
  var histogram = ui.Chart.image.histogram({
    image: change,
    region: aoi,
    scale: 30,
    minBucketWidth: 10
    });
    histogram.setOptions({
    title: 'Histogram of surface water change intensity.'
    });
    
  // Replace the existing chart in the chart panel with the new chart.
  chartPanel.widgets().reset([histogram]);
  }
  
  else if (graph == piechart){
    var area_image_with_transition_class = ee.Image.pixelArea().addBands(transition);

  var reduction_results = area_image_with_transition_class.reduceRegion({
    reducer: ee.Reducer.sum().group({
      groupField: 1,
      groupName: 'transition_class_value',
    }),
    geometry: aoi,
    scale: 30,
    bestEffort: true,
  });
  //print('reduction_results', reduction_results);
  
  // summary chart
  var roi_stats = ee.List(reduction_results.get('groups'));
  // Create a dictionary for looking up names of transition classes.
  var lookup_names = ee.Dictionary.fromLists(
      ee.List(gsw.get('transition_class_values')).map(ee.String),
      gsw.get('transition_class_names')
  );
  // Create a dictionary for looking up colors of transition classes.
  var lookup_palette = ee.Dictionary.fromLists(
      ee.List(gsw.get('transition_class_values')).map(ee.String),
      gsw.get('transition_class_palette')
  );
  
  // Create a feature for a transition class that includes the area covered.
  function createFeature(transition_class_stats) {
    transition_class_stats = ee.Dictionary(transition_class_stats);
    var class_number = transition_class_stats.get('transition_class_value');
    var result = {
        transition_class_number: class_number,
        transition_class_name: lookup_names.get(class_number),
        transition_class_palette: lookup_palette.get(class_number),
        area_m2: transition_class_stats.get('sum')
    };
    return ee.Feature(null, result);   // Creates a feature without a geometry.
  }
  
  // Create a JSON dictionary that defines piechart colors based on the
  // transition class palette.
  function createPieChartSliceDictionary(fc) {
    return ee.List(fc.aggregate_array("transition_class_palette"))
      .map(function(p) { return {'color': p}; }).getInfo();
  }
  
  
  var transition_fc = ee.FeatureCollection(roi_stats.map(createFeature));
  //print('transition_fc', transition_fc);
  
  
  // Add a summary chart.
  var transition_summary_chart = ui.Chart.feature.byFeature({
      features: transition_fc,
      xProperty: 'transition_class_name',
      yProperties: ['area_m2', 'transition_class_number']
    })
    .setChartType('PieChart')
    .setOptions({
      title: 'Summary of transition class areas',
      slices: createPieChartSliceDictionary(transition_fc),
      sliceVisibilityThreshold: 0  // Don't group small slices.
    });
    
  chartPanel.widgets().reset([transition_summary_chart]);
  }
  
  else if (graph == fading){
    
   var col = ee.ImageCollection('JRC/GSW1_1/YearlyHistory').map(function(img) {
   var year = img.date().get('year');
   var yearImg = img.gte(2).multiply(year);
   var despeckle = yearImg.connectedPixelCount(15, true).eq(15);
   return yearImg.updateMask(despeckle).selfMask().set('year', year);
  });
  
  //function that reverse frame sequence once the end is reached
  
  function appendReverse(col) {
   return col.merge(col.sort('year', false));
  }
  
  var bgColor = '000000'; // Assign white to background pixels.
  var riverColor = '0D0887'; // Assign blue to river pixels.
  var annualCol = col.map(function(img) {
   return img.unmask(0)
   .visualize({min: 0, max: 1, palette: [bgColor, riverColor]})
   .set('year', img.get('year'));
  });
  var basicAnimation = appendReverse(annualCol);
  
  
  var bgImg = ee.Image(1).visualize({palette: bgColor});
  var fadeFilter = ee.Image(1).visualize({palette: bgColor, opacity: 0.1});
  var fadeFilterCol = col.map(function(img) {
   var imgVis = img.visualize({palette: riverColor});
   return imgVis.blend(fadeFilter).set('year', img.get('year'));
  });
  var yearSeq = ee.List.sequence(1984, 2018);
  var fadeCol = ee.ImageCollection.fromImages(yearSeq.map(function(year) {
   var fadeComp =
   fadeFilterCol.filter(ee.Filter.lte('year', year)).sort('year').mosaic();
   var thisYearImg = col.filter(ee.Filter.eq('year', year)).first().visualize({
   palette: riverColor
   });
   return bgImg.blend(fadeComp).blend(thisYearImg).set('year', year);
  }));
  //print(ui.Thumbnail(appendReverse(fadeCol), videoArgs));
  var r = ui.Thumbnail(appendReverse(fadeCol), videoArgs)

  // Replace the existing chart in the chart panel with the new chart.
  chartPanel.widgets().reset([r]);

  }
  
  else if (graph== cumulative){
    
    var cumulativeVis = {
      min: 1984,
      max: 2018,
      palette: ['FEF720', '9BFA24', '31DB92', '27BBE0', '0D0887']
      };
    var cumulativeFilterCol = col.map(function(img) {
      return img.visualize(cumulativeVis).set('year', img.get('year'));
      });
    var cumulativeCol = ee.ImageCollection.fromImages(yearSeq.map(function(year) {
    var cumulativeComp = cumulativeFilterCol.filter(ee.Filter.lte('year', year))
      .sort('year')
      .mosaic();
      return bgImg.blend(cumulativeComp).set('year', year);
      }));
      // print(ui.Thumbnail(appendReverse(cumulativeCol), videoArgs));
    var r = ui.Thumbnail(appendReverse(cumulativeCol), videoArgs)
    chartPanel.widgets().reset([r]);
  
  }
  else if(graph==ndvi){
    var mapScale = Map.getScale();
    var scale = mapScale > 5000 ? mapScale * 2 : 5000;
    var chart = ui.Chart.image
                  .seriesByRegion({
                    imageCollection: ee.ImageCollection('MODIS/006/MOD13A2'),
                    regions: aoi,
                    reducer: ee.Reducer.mean(),
                    band: 'NDVI',
                    scale: scale,
                    xProperty: 'system:time_start'
                  })
                  .setOptions({
                    titlePostion: 'none',
                    legend: {position: 'none'},
                    hAxis: {title: 'Date'},
                    vAxis: {title: 'NDVI (x1e4)'},
                    series: {0: {color: '23cba7'}}
                  });

  // Replace the existing chart in the chart panel with the new chart.
  chartPanel.widgets().reset([chart]);}
  else if(graph==losses){
  var lossByYear = lossAreaImage.addBands(lossYear).reduceRegion({
  reducer: ee.Reducer.sum().group({
    groupField: 1
    }),
  geometry: aoi,
  scale: 30,
  maxPixels: 1e9,
  bestEffort:true
});
var statsFormatted = ee.List(lossByYear.get('groups'))
  .map(function(el) {
    var d = ee.Dictionary(el);
    return [ee.Number(d.get('group')).format("20%02d"), d.get('sum')];
  });
var statsDictionary = ee.Dictionary(statsFormatted.flatten());
print(statsDictionary);
// Chart NDVI time series for the selected area of interest.
var chart1 =ui.Chart.array.values({
  array: statsDictionary.values(),
  axis: 0,
  xLabels: statsDictionary.keys()
}).setChartType('ColumnChart')
  .setOptions({
    title:'  Yearly Vegetation Loss\n total losses for detecated area = 67645.81176470588',
    hAxis: {title: 'Year', format: '####'},
    vAxis: {title: 'Area (square meters)'},
    legend: { position: "none" },
    lineWidth: 1,
    pointSize: 3
   });  // Replace the existing chart in the chart panel with the new chart.
 
 chartPanel.widgets().reset([chart1]);}
}

drawingTools.onDraw(ui.util.debounce(selectchart, 500));
drawingTools.onEdit(ui.util.debounce(selectchart, 500));


var viridis = {min: 1984 , max : 2018,
              palette : ['FEF720', '9BFA24', '31DB92', '27BBE0', '0D0887']};
var lon = ee.Image.pixelLonLat().select('longitude');
var gradient = lon.multiply((viridis.max-viridis.min)/100.0).add(viridis.min);

var symbol = {
  rectangle: '⬛',

};

var controlPanel= ui.Panel({
  widgets: [ui.Label({
        value: 'select a drawing mode then select analysis',
        style: {backgroundColor :'rgba(240,240,240,0.5)',fontWeight:'bold'}
      }),
    ui.Button({
      label: symbol.rectangle + ' Rectangle',
      onClick: drawRectangle,
      style: {stretch: 'horizontal'}
    }),
    // ui.Button({
    //   label: symbol.polygon + ' Polygon',
    //   onClick: drawPolygon,
    //   style: {stretch: 'horizontal'}
    // }),
    ui.Button({
      label:'Clear animation',
      onClick: clearanimation,
      style: {stretch: 'horizontal'}
    }),
    graphSelect
    
  ],
  style: {position: 'top-left',width:'300px',height: '400px', backgroundColor :'rgba(125,125,125,0.5)'},
  layout: null,
});

function makeLegend2 (viridis) {
  var lon = ee.Image.pixelLonLat().select('longitude');
  var gradient = lon.multiply((viridis.max-viridis.min)/100.0).add(viridis.min);
  var legendImage = gradient.visualize(viridis);
  
  var years = ui.Panel({
    widgets:[
      ui.Label({
        value: 'most recent year of water occuracy',
        style: {backgroundColor :'rgba(200,200,200,0.5)',fontWeight:'bold'}
      })],
      layout: ui.Panel.Layout.flow('horizontal'),
    style: {stretch: 'horizontal', maxWidth: '270px', padding: '0px 0px 0px 8px',backgroundColor:'rgba(125,125,125,0.5)'}
  })
  var thumb = ui.Thumbnail({
    image: gradient.visualize(viridis), 
    params: {bbox:'0,0,100,8', dimensions:'256x20'},  
    style: {position: 'bottom-center',backgroundColor:'rgba(125,125,125,0.5)'}
  });
  var panel2 = ui.Panel({
    widgets: [
      ui.Label({
        value: '1984',
        style: {backgroundColor :'rgba(200,200,200,0.5)',fontWeight:'bold'}
      }), 
      ui.Label({style: {stretch: 'horizontal',backgroundColor:'rgba(125,125,125,0.5)'}}), 
      ui.Label({
        value: '2018',
        style: {backgroundColor :'rgba(200,200,200,0.5)',fontWeight:'bold'}
      })
    ],
    layout: ui.Panel.Layout.flow('horizontal'),
    style: {stretch: 'horizontal', maxWidth: '270px', padding: '0px 0px 0px 8px',backgroundColor:'rgba(125,125,125,0.5)'}
  });
  return ui.Panel().add(years).add(thumb).add(panel2);
}
Map.add(controlPanel)
controlPanel.add(makeLegend2(viridis))
            
// ui.root.insert(1,graphSelect) 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//add layers of losses
var treeCover = gfc2020.select(['treecover2000']);
var lossImage = gfc2020.select(['loss']);
var gainImage = gfc2020.select(['gain']);
var VIS_OCCURRENCE = {
  min:0,
  max:100,
  palette: ['red', 'blue']
};
//Threshold Layer
var VIS_WATER_MASK = {
  palette: ['white', 'black']
};
//selecting transition layer 
var transition = gsw.select('transition');
var water_mask = occurrence.gt(90).unmask(1);
var checkbox1 = ui.Checkbox('Show vegetation areas',true);

checkbox1.onChange(function(checked) {
  // Shows or hides the first map layer based on the checkbox's value.
  Map.layers().get(0).setShown(checked);
});
var checkbox2 = ui.Checkbox('Show gain areas', true);

checkbox2.onChange(function(checked) {
  // Shows or hides the first map layer based on the checkbox's value.
  Map.layers().get(1).setShown(checked);
});

var checkbox3 = ui.Checkbox('Show losses areas', true);

checkbox3.onChange(function(checked) {
  // Shows or hides the first map layer based on the checkbox's value.
  Map.layers().get(2).setShown(checked);
});
var checkbox4 = ui.Checkbox( '"Water Occurrence (1984-2015)"', true);

checkbox4.onChange(function(checked) {
  // Shows or hides the first map layer based on the checkbox's value.
  Map.layers().get(3).setShown(checked);
});
var checkbox5 = ui.Checkbox('90% occurrence water mask', true);

checkbox5.onChange(function(checked) {
  // Shows or hides the first map layer based on the checkbox's value.
  Map.layers().get(4).setShown(checked);
});
var checkbox6 = ui.Checkbox('Transition classes (1984-2015)', true);

checkbox6.onChange(function(checked) {
  // Shows or hides the first map layer based on the checkbox's value.
  Map.layers().get(5).setShown(checked);
});
var slider1 = ui.Slider({style: {backgroundColor :'rgba(140,140,140,0.5)'}});

slider1.setValue(0.9);  // Set a default value.
slider1.onChange(function(value) {
  Map.layers().get(0).setOpacity(value);
});
var slider2 = ui.Slider({style: {backgroundColor :'rgba(140,140,140,0.5)'}});

slider2.setValue(0.9);  // Set a default value.
slider2.onChange(function(value) {
  Map.layers().get(1).setOpacity(value);
});
var slider3 = ui.Slider({style: {backgroundColor :'rgba(140,140,140,0.5)'}});

slider3.setValue(0.9);  // Set a default value.
slider3.onChange(function(value) {
  Map.layers().get(2).setOpacity(value);
});

var slider4 = ui.Slider({style: {backgroundColor :'rgba(140,140,140,0.5)'}});

slider4.setValue(0.9);  // Set a default value.
slider4.onChange(function(value) {
  Map.layers().get(3).setOpacity(value);
});


var slider5 = ui.Slider({style: {backgroundColor :'rgba(140,140,140,0.5)'}});

slider5.setValue(0.9);  // Set a default value.
slider5.onChange(function(value) {
  Map.layers().get(4).setOpacity(value);
});
var slider6 = ui.Slider({style: {backgroundColor :'rgba(140,140,140,0.5)'}});

slider6.setValue(0.9);  // Set a default value.
slider6.onChange(function(value) {
  Map.layers().get(5).setOpacity(value);
});
///////////////////////////////////////////////

// Add the tree cover layer in green.
Map.addLayer(treeCover.updateMask(treeCover).clip(delta),
    {palette: ['000000', '00FF00'], max: 100}, 'vegetation Cover');

// Add the gain layer in blue.
Map.addLayer(gainImage.updateMask(gainImage).clip(delta),
            {palette: ['0000FF']}, 'Gain');

// Add the loss layer in red.
Map.addLayer(lossImage.updateMask(lossImage).clip(delta),
            {palette: ['FF0000']}, 'Loss');

// ///////////////
//add layer of water cover 

Map.addLayer({
  eeObject: occurrence.updateMask(occurrence.divide(100)),
  name: "Water Occurrence (1984-2015)",
  visParams: VIS_OCCURRENCE,
});

// Create a mask on non-water areas with occurance < 90%
Map.addLayer({
  eeObject: water_mask,
  visParams: VIS_WATER_MASK,
  name: '90% occurrence water mask',
});

Map.addLayer({
  eeObject: transition,
  name: 'Transition classes (1984-2015)',
});


controlPanel.add(checkbox1).add(slider1)
.add(checkbox2).add(slider2)
.add(checkbox3).add(slider3)
.add(checkbox4).add(slider4)
.add(checkbox5).add(slider5)
.add(checkbox6).add(slider6);

// ///////////
// /////////
