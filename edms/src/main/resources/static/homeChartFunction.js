/*
	home.jsp에 출력될 차트 관련 함수
*/

	$(function() {
    // 페이지 로딩 완료 후 실행됩니다.
    $.ajax({
        url: '/getSalesDraftForMorrisChart', // 서버에 요청할 URL입니다.
        method: 'GET', // HTTP 메서드입니다. 여기서는 GET을 사용합니다.
        success: function(data){
            // 요청이 성공적으로 완료되면 이 함수가 호출됩니다. 
            console.log('Raw data:', data); // 서버로부터 받은 원시 데이터를 콘솔에 출력합니다.

            var productCategories = ['스탠드','무드등','실내조명','실외조명','포인트조명'];  // 상품 카테고리 배열입니다.
            var chartData = {};  // 차트 데이터를 저장할 객체입니다.

            for (var i=0; i<data.length; i++) {
                var item = data[i];  // 데이터 배열의 각 항목을 순회합니다.
                var monthKey = item.salesDate.slice(0,7);  // 'yyyy-MM' 형식으로 날짜를 변환합니다.

                if (!chartData[monthKey]) {
                    chartData[monthKey] = {};  // 해당 월의 데이터가 없으면 초기화 합니다.
                    for (var j=0; j<productCategories.length; j++) {
                        chartData[monthKey][productCategories[j]] = 0;  // 각 상품 카테고리별로 초기값을 설정합니다.
                    }
                }

                if (productCategories.includes(item.productCategory)) {
                    chartData[monthKey][item.productCategory] += item.targetRate;
                    	// 해당 상품 카테고리의 매출액을 더해줍니다.
                }
            }

            console.log('Intermediate data:', chartData); 	// 중간 결과 데이터를 콘솔에 출력합니다.

            var formatted_data=[];

			// 2중 for문 사용
            for(var key in chartData){
                var item={period:key};
                
                	// 차트에서 사용할 수 있는 형태로 데이터를 변환합니다. 
                	// period 속성은 x축(시간) 값을 나타냅니다.
                
                for(var subkey in chartData[key]){
                    item[subkey]=chartData[key][subkey];
                    	// 각 상품 카테고리별 목표달성률을 추가합니다. 
                    	// 이 값들은 y축(목표달성률) 값을 나타냅니다.
                    
                }
                
                formatted_data.push(item); 	// 변환된 데이터를 배열에 추가합니다.
            }

            console.log('Formatted data:', formatted_data); // 최종 차트 데이터를 콘솔에 출력합니다.

            Morris.Area({
                element: 'morris-area-chart',  // 차트가 그려질 HTML 요소의 ID입니다.
                data: formatted_data,  // 차트 데이터입니다.
                xkey: 'period',  // x축의 값이 될 속성 이름입니다.
                ykeys: productCategories,  // y축의 값이 될 속성 이름들입니다.
                labels: productCategories,  // 각 선(상품 카테고리)에 대한 라벨입니다.
				pointSize: 3,
				fillOpacity: 0,
				pointStrokeColors:['#5f76e8','#01caf1','#fa292a','#00ff00','#0000ff'],
				behaveLikeLine : true,
				gridLineColor : '#e0e0e0',
				lineWidth :3,
				hideHover : 'auto',
			        lineColors:['#5f76e8','#01caf1','#fa292a','#00ff00','#0000ff'], 
			  	resize:true
			        });
			      },
			      
			error:function(textStatus, errorThrown){  
			    	console.log("Error", textStatus, errorThrown);
			    	    	// 요청이 실패하면 이 함수가 호출됩니다. 
			    	    	// 실패한 이유를 콘솔에 출력합니다. 
	    }
    });
});

