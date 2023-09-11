/*
	home.jsp에 출력될 차트 관련 함수
*/

$(function() {
    $.ajax({
        url: '/getSalesDraftForMorrisChart',
        method: 'GET',
        success: function(data){
            console.log('Raw data:', data);

            var chartData = {};
            
            for (var i=0; i<data.length; i++) {
                var item = data[i];
                var monthKey = item.salesDate.slice(0,7);

                if (!chartData[monthKey]) {
                    chartData[monthKey] = { count: 0, totalRate: 0 };
                }

                chartData[monthKey].count += 1;
                chartData[monthKey].totalRate += item.targetRate;
            }

            console.log('Intermediate data:', chartData);
            
            var formatted_data=[];

			for(var key in chartData){
				var averageRate = (chartData[key].totalRate / chartData[key].count).toFixed(2);
				formatted_data.push({period:key, averageTargetRate:averageRate});
			}

			console.log('Formatted data:', formatted_data);

			Morris.Area({
				element: 'morris-area-chart',
				data: formatted_data,
				xkey: 'period',
				ykeys:['averageTargetRate'],
				labels:['Average Target Rate'],
		        pointSize : 3,
		        fillOpacity : 0,
		        pointStrokeColors : ['#5f76e8'],
		        behaveLikeLine : true,
		        gridLineColor : '#e0e0e0',
		        lineWidth :3,
		        hideHover :'auto',
		      	lineColors:['#5f76e8'], 
			  	resize:true,
			  	yLabelFormat:function(y){return(y*100).toFixed(2)+'%';}
			});
	    },
	    error:function(textStatus,errorThrown){  
	    	console.log("Error",textStatus,errorThrown); 
	    }
    });

    
    // 도넛 차트
    $.ajax({
		url : '/getSalesDraftForDonutChart',
		method : 'get',
		success : function(data) {
			let salesDate = data[0].salesDate; // "yyyy-mm-dd" 형식의 날짜 문자열
			let dateObj = new Date(salesDate);
			let chartMonth = dateObj.getFullYear() + '년 ' + (dateObj.getMonth() + 1) + '월';
			
			console.log('chartMonth : ' + chartMonth);
			$('#tagetMonth').text(chartMonth);
			
			var chartData = data.map(function (item) {
	            return {
	                label: item.productCategory,
	                value: item.currentSales
	            };
	        });

	        Morris.Donut({
	            element: 'morris-donut-chart',
	            data: chartData, // 변환된 데이터를 사용
	            resize: true,
	            colors: ['#5f76e8', '#01caf1', '#8fa0f3', '#4caf50', '#8bc34a'],
	            formatter: function (y) {
			        return y.toLocaleString() + '원'; // 값에 쉼표 추가
			    }
	        });
		},
		error : function(error) {
				console.log('error : ' + error);
		}
	});
	
	// 바 차트
	$.ajax({
		url : '/getSalesDraftForBarChart',
		method : 'get',
		success : function(data) {
			// 데이터 가공
			let processedData = {};
			data.forEach(function(item) {
			    let salesDate = item.salesDate.slice(0, -3);
			    let targetRate = item.targetRate;
			    let productCategory = item.productCategory;
			
			    if (!processedData[salesDate]) {
			        processedData[salesDate] = {};
			    }
			    
			    processedData[salesDate][productCategory] = targetRate;
			});
			
			let chartData = [];
			for (let date in processedData) {
			    let dataItem = processedData[date];
			    dataItem['y'] = date;
			    chartData.push(dataItem);
			}
			
			// Morris Bar 차트 생성
			Morris.Bar({
			    element: 'morris-bar-chart',
			    data: chartData,
			    xkey: 'y',
			    ykeys: ['스탠드', '무드등', '실내조명', '실외조명', '포인트조명'],
			    labels: ['스탠드', '무드등', '실내조명', '실외조명', '포인트조명'],
			    barColors: ['#01caf1', '#5f76e8', '#a6c7ff', '#00a2ff', '#7ec0ee'],
			    hideHover: 'auto',
			    gridLineColor: '#eef0f2',
			    resize: true,
			    yLabelFormat: function (y) { return (y * 100).toFixed(0) + '%'; } // y 라벨 포맷 설정 (targetRate를 백분율로 변환)
			});
		},
		error : function(error) {
				console.log('error : ' + error);
		}
	});
});

