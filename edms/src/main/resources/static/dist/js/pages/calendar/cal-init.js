! function($) {
    "use strict";

    var CalendarApp = function() {
        this.$body = $("body") // 현재 페이지의 body 요소를 찾아 변수에 저장
        this.$calendar = $('#calendar'),
        this.$event = ('#calendar-events div.calendar-events'), // 캘린더 이벤트를 담고 있는 요소를 찾아 변수에 저장
        this.$categoryForm = $('#add-new-event form'), // 이벤트 카테고리를 추가하는 폼을 찾아 변수에 저장
        this.$extEvents = $('#calendar-events'), // 캘린더 외부 이벤트를 담고 있는 요소를 찾아 변수에 저장
        this.$modal = $('#my-event'), // 이벤트를 표시하기 위한 모달 요소를 찾아 변수에 저장
        this.$saveCategoryBtn = $('.save-category'), // 카테고리를 저장하는 버튼 요소를 찾아 변수에 저장
        this.$calendarObj = null // 캘린더 객체를 저장할 변수를 초기화, null로 기본값 설정
    };


    /* 이벤트 객체가 캘린더에 드롭되었을 때 실행할 함수를 정의 -> 원본 이벤트 객체를 복사, 새로운 날짜 및 클래스 할당, 캘린더에 렌더링, 필요에 따라 드룹 후 이벤트 객체 삭제*/
    CalendarApp.prototype.onDrop = function(eventObj, date) {
            var $this = this; // 현재 코드 스코프의 this를 다른 변수에 저장하여 하위 스코프에서 사용
            
            // 드롭된 요소의 저장된 Event Object를 검색
            var originalEventObject = eventObj.data('eventObject');
            var $categoryClass = eventObj.attr('data-class');
            
            // 동일한 객체에 대한 참조가 여러 이벤트에 있지 않도록 복사
            var copiedEventObject = $.extend({}, originalEventObject);
            
            // 리포트된 날짜를 할당
            copiedEventObject.start = date;
            
            // 카테고리 클래스가 있으면 해당 클래스를 추가
            if ($categoryClass)
                copiedEventObject['className'] = [$categoryClass];
                
            // 캘린더에 이벤트를 렌더링
            $this.$calendar.fullCalendar('renderEvent', copiedEventObject, true);
            
            // 드롭 후 삭제 체크박스가 선택되었는지 확인
            if ($('#drop-remove').is(':checked')) {
                // 선택된 경우, 드래그 가능한 이벤트 목록에서 요소를 제거
                eventObj.remove();
            }
        },
        // 이벤트 드래그 기능을 활성화하는 메소드를 정의 -> 이벤트 객체 생성, DOM 요소에 저장 후 jQuery UI를 사용하여 드래그 기능을 추가 
        // 드래그 후 이벤트가 원래 위치로 돌아가도록 revert 속성을 설정
        CalendarApp.prototype.enableDrag = function() {
			
            //이벤트 초기화
            $(this.$event).each(function() {
				
                // 이벤트 객체를 생성 옆의 링크 참조 (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
                // start나 end가 필요하지 않음
                var eventObject = {
                    title: $.trim($(this).text()) // 요소의 텍스트를 잘라서 이벤트 제목으로 사용
                };
                
                // 이벤트 객체를 DOM 요소에 저장하여 나중에 사용할 수 있도록 함
                $(this).data('eventObject', eventObject);
                
                // jQuery UI를 사용하여 이벤트를 드래그 가능하게 만듬
                $(this).draggable({
                    zIndex: 999,
                    revert: true, // 드래그 이후 이벤트를 원래 위치로 되돌린다.
                    revertDuration: 0 // 원래 위치로 되돌아가는데 걸리는 시간(숫자가 클수록 느림)
                });
            });
        }
        
    /* 초기화 메서드 정의 -> 드래그 기능 활성화 후 캘린더 초기화 하고 기본 이벤트 배열을 작성, 배열에는 테마에 따른 이벤트 데이터가 있음. 
    이벤트 배열은 defaultEvents 변수에 저장되며 이후 캘린더 이벤트를 표시할 때 사용됨 */
    CalendarApp.prototype.init = function(initData) {
            this.enableDrag(); // 드래그 기능 활성화
            
            /*  캘린더 초기화  */
            var date = new Date();
            var d = date.getDate();
            var m = date.getMonth();
            var y = date.getFullYear();
            var form = '';
            var today = new Date($.now());
			
			
			// 기본 이벤트 배열을 정의 -> start 속성만 있는 경우 하루 동안 발생, end 속성이 있는 경우 여러 날에 걸쳐 진행됨.
            var defaultEvents = [{
                    title: 'Meeting #3',
                    start: new Date($.now() + 506800000), // 현재 시간에서 506800000밀리초 만큼 더함(약 5일 20시간 52분 정도를 더함)
                    className: 'bg-info' // 이 값을 통해 추가된 일정의 색을 표현
                }, {
                    title: 'Submission #1',
                    start: today,
                    end: today,
                    className: 'bg-danger'
                }, {
                    title: 'Meetup #6',
                    start: new Date($.now() + 848000000),
                    className: 'bg-info'
                }, {
                    title: 'Seminar #4',
                    start: new Date($.now() - 1099000000),
                    end: new Date($.now() - 919000000),
                    className: 'bg-warning'
                }, {
                    title: 'Event Conf.',
                    start: new Date($.now() - 1199000000),
                    end: new Date($.now() - 1199000000),
                    className: 'bg-purple'
                }, {
                    title: 'Meeting #5',
                    start: new Date($.now() - 399000000),
                    end: new Date($.now() - 219000000),
                    className: 'bg-info'
                },
                {
                    title: 'Submission #2',
                    start: new Date($.now() + 868000000),
                    className: 'bg-danger'
                }, {
                    title: 'Seminar #5',
                    start: new Date($.now() + 348000000),
                    className: 'bg-success'
                }
            ];
			
			// 현재 객체를 참조하기 위해 $this 변수에 할당
            var $this = this;
            // $this.$calendar 객체에 fullCalendar를 설정하고 $this.$calendarObj에 할당한다.
            $this.$calendarObj = $this.$calendar.fullCalendar({
				
				dayClick: function(date, jsEvent, view) {
			        // date 객체는 클릭된 날짜 정보를 포함하고 있습니다.
			        // 원하는 페이지로 리다이렉트합니다. 예시로 '/detail' 페이지로 리다이렉트하는 코드입니다.
			        window.location.href = '/schedule/scheduleDay?date=' + date.format();
			    },
				
				// 하루를 15분 단위로 분할하려면 이 값을 설정
                slotDuration: '00:15:00',
                
                /* 캘린더에 표기되는 최소 시간을 설정(08시) */
                minTime: '08:00:00',
                
                // 캘린더에 표기되는 최대 시간을 설정(19시)
                maxTime: '19:00:00',
                
                // 캘린더의 기본 뷰를 선택(월별 뷰)
                defaultView: 'month',
                
                // 창 크기 조절시 캘린더 크기도 함께 조절되게 설정
                handleWindowResize: true,

                header: {
					// 왼쪽 상단에 오늘 버튼을 배치
                    left: 'today',
                    // 중앙 상단에 이전, 캘린더 제목, 다음을 표시
                    center: 'prev title next',
                    // 오른쪽 상단에 월별 뷰, 일별 뷰를 선택할 수 있는 버튼을 배치합니다.
                    right: 'month,agendaDay'
                    // ,agendaWeek 주간 뷰 제외
                },
                
			    // 여기에서도 initData의 값을 사용합니다.(initData.scheduleEvents와 initData.reservationEvents를 입력)
			    eventSources: [
			    	{
			          events: initData.scheduleEvents,
			    	},
			    	{
			          events: initData.reservationEvents,
			    	},
			    ],
                
                // 앞서 설정한 defaultEvent 배열을 이용하여 이벤트 데이터를 로드
                // events: defaultEvents,
                
                // 이벤트 수정이 가능한지 여부를 설정(true: 가능, false: 불가능)
                editable: true,
                // 캘린더에 항목을 끌어다 놓을 수 있는지 설정
                droppable: true, 
                // 너무 많은 이벤트가 있을 경우 "더보기" 링크를 허용
                eventLimit: true, 
                // 캘린더에서 날짜를 선택할 수 있는지 설정
                selectable: true,
                // 캘린더에 드롭 이벤트가 발생했을 때 호출되는 함수를 설정
                drop: function(date) { $this.onDrop($(this), date); },
                // 사용자가 캘린더에서 날짜를 선택했을때 호출되는 함수를 설정
                select: function(start, end, allDay) { $this.onSelect(start, end, allDay); },
                // 캘린더에서 이벤트를 클릭했을 떄 호출되는 함수를 설정
                eventClick: function(calEvent, jsEvent, view) { $this.onEventClick(calEvent, jsEvent, view); }

            });
            
        },

        // CalendarApp 객체 생성 및 초기화 -> CalendarApp 객체 생성 후 생성자(Constructor)를 CalendarApp로 설정해서 CalendarApp 객체를 사용이 가능
        $.CalendarApp = new CalendarApp, $.CalendarApp.Constructor = CalendarApp

}(window.jQuery),

// CalendarApp 초기화 실행 -> 웹 페이지가 완전히 로드된 후 실행되는 함수로 객체를 초기화함
// $(window).on('load', function() {
$(document).ready(function() {
		
	// 여기에서 서버에서 가져온 initData를 정의하거나 Ajax를 사용하여 가져온다.
    var initData = {
        scheduleEvents:scheduleEvents, // DB에서 가져온 일정 이벤트 데이터
        reservationEvents:reservationEvents, // DB에서 가져온 예약 이벤트 데이터
    };
	
	// 웹 페이지가 완전히 로드되면 실행되는 함수로 객체를 초기화함 -> initData를 매개변수로 추가
    $.CalendarApp.init(initData) 
});