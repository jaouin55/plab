<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%@ page import="java.util.*" %>
<%@ page import="plaber.PlabService" %>

<%
    if (!Boolean.TRUE.equals(session.getAttribute("LOGIN"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLAB PLABER</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: #f4f6f9;
            font-family: 'Segoe UI', 'Malgun Gothic', sans-serif;
            color: #333;
            overflow-x:hidden;
        }

        .header {
            height: 60px;
            background: linear-gradient(45deg, black, transparent);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            font-weight: bold;
            box-shadow: 0 2px 10px rgba(0, 0, 0, .15);
            margin-bottom: 20px;
        }

        .logo {
            letter-spacing: 5px;
        }

        .search-wrap,
        .content {
            width: min(1200px, 95%);
            margin-left:auto;
            margin-right:auto;
        }

        .search-box {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, .08);
            padding: 25px;
            display:grid;
            grid-template-columns:repeat(auto-fit, minmax(180px,1fr));
            gap:20px;
            align-items: end;
        }

        .item {
            display: flex;
            flex-direction: column;
        }

        .item label {
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: bold;
            color: #555;
        }

        .item select {
            height: 42px;
            border: 1px solid #dcdcdc;
            border-radius: 8px;
            padding: 0 12px;
            font-size: 14px;
            transition: .2s;
        }

        .item select:focus {
            outline: none;
            border-color: #ff6b00;
            box-shadow: 0 0 0 3px rgba(255, 107, 0, .15);
        }

        .btn-area {
            display: flex;
            align-items: flex-end;
        }

        .search-btn {
            width: 100%;
            height: 42px;
            border: 0;
            border-radius: 8px;
            background: #666666;
            color: #f4f6f9;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: .2s;
        }

        .search-btn:hover {
            background: #333333;
            color:#ffffff;
            transform:translateY(-1px);
            box-shadow:
                    0 5px 5px rgba(0,0,0,.1);
        }

        .match-list {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .match-card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, .08);
            transition: .25s;
            overflow: hidden;
        }

        .match-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, .15);
        }

        @media(max-width:650px){


            .stadium{
                font-size:18px;
            }


            .schedule{
                font-size:14px;
            }


            .badge-wrap{
                margin-top:15px;
            }

            .summary {
                grid-template-columns:1fr;
            }

            .level {
                margin-top: 15px;
            }

            .tier-table th,
            .tier-table td {
                display: block;
                width: 100%;
            }

        }

        .card-header{
            padding:18px;
            flex-direction: column;
            align-items: flex-start;
        }

        .card-header>div:first-child{
            flex:1;
        }

        .stadium{
            font-size:22px;
            font-weight:bold;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
        }

        .schedule {
            margin-top: 8px;
            color: #333333;
            font-size: 16px;
        }

        .level {
            padding: 8px 20px;
            border-radius: 30px;
            color: white;
            font-weight: bold;
        }

        .normal {
            background: #f1c40f;
            color: #222;
        }

        .hard {
            background: #e74c3c;
        }

        .card-body{
            padding:18px 25px;
        }

        .summary {
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(130px,1fr));
            gap: 15px;
            margin-bottom: 25px;
        }

        .summary-item {
            background: orangered;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
        }

        .summary-item .title {
            font-size: 13px;
            color: #888;
        }

        .summary-item .value {
            margin-top: 8px;
            font-size: 22px;
            font-weight: bold;
            color: lightcoral;
        }

        .tier-table {
            width: 100%;
            border-collapse: collapse;
        }

        .tier-table tr {
            border-bottom: 1px solid #efefef;
        }

        .tier-table th {
            background: #fafafa;
            width: 180px;
            text-align: left;
            padding: 15px;
        }

        .tier-table td {
            padding: 15px;
        }

        .tier-table b {
            color: #ff6b00;
        }

        .empty-box {
            background: white;
            padding: 50px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 3px 15px rgba(0, 0, 0, .08);
        }

        .empty-icon {
            font-size: 50px;
        }

        .empty-title {
            margin-top: 20px;
            font-size: 20px;
            font-weight: bold;
        }

        .empty-desc {
            margin-top: 10px;
            color: #888;
        }

        @media (max-width: 1200px) {
            .search-wrap,
            .content {
                width: 95%;
            }
        }

        @media (max-width: 900px) {
            .search-box {
                grid-template-columns:1fr;
            }

            .summary {
                grid-template-columns:repeat(2, 1fr);
            }
        }



        .loading-mask{
            position:fixed;
            left:0;
            top:0;
            width:100%;
            height:100%;
            background:rgba(0,0,0,0.35);
            z-index:99999;

            display:flex;
            justify-content:center;
            align-items:center;
        }

        .loading-box{
            background:#fff;
            padding:30px 40px;
            border-radius:10px;
            text-align:center;
            box-shadow:0 10px 30px rgba(0,0,0,.2);
        }

        .loading-text{
            margin-top:15px;
            font-size:15px;
            font-weight:bold;
        }

        .spinner{
            width:45px;
            height:45px;
            border:5px solid #ddd;
            border-top:5px solid #2196F3;
            border-radius:50%;
            animation:spin .8s linear infinite;
            margin:auto;
        }

        @keyframes spin{
            from{
                transform:rotate(0deg);
            }
            to{
                transform:rotate(360deg);
            }
        }

        .woman-badge{
            background:#ff4d6d;
            color:#fff;
            padding:7px 14px;
            border-radius:20px;
            font-size:13px;
            font-weight:bold;
            margin-left:15px;
        }

        .match-info{
            display:flex;
            align-items:center;
            gap:12px;
            flex-wrap:wrap;
            font-size:15px;
            color:#555;
        }

        .match-info b{
            color:#ff6b00;
        }

        .match-info span{
            color:#bbb;
            margin:0 8px;
        }

        .divider{
            color:#ccc;
        }

        .woman-badge{
            margin-left:auto;
        }

        .card-header>div:first-child{
            flex:1;
            min-width:0;
        }

        .match-link{
            color:cornflowerblue;
            text-decoration:none;
            font-weight:bold;
        }

        .match-link:hover{
            color:#0d47a1;
            text-decoration:underline;
        }

        .woman-badge{
            background:#ff4d6d;
            color:#fff;
            padding:6px 12px;
            border-radius:20px;
            font-size:13px;
            font-weight:bold;
        }

        .low-level-badge{
            background:#1976d2;
            color:#fff;
            padding:6px 12px;
            border-radius:20px;
            font-size:13px;
            font-weight:bold;
        }

        .badge-wrap{
            display:flex;
            gap:8px;
            align-items:center;
            margin-top: 15px;
            justify-content: end;
        }

        .result-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin:20px 0 16px;
        }

        .total{
            display:flex;
            align-items:center;
            font-size:18px;
            font-weight:500;
            line-height:40px;   /* select 높이와 맞춤 */
        }

        .total b{
            margin:0 4px;
            color:#0d6efd;
            font-size:22px;
        }

        #sortType{
            height:40px;
            line-height:40px;
            padding:0 14px;
            border:1px solid #dcdfe6;
            border-radius:10px;
            background:#fff;
            font-size:14px;
            cursor:pointer;
            appearance:none;
            -webkit-appearance:none;
            -moz-appearance:none;

            /* 화살표 */
            background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24'%3E%3Cpath fill='%23666' d='M7 10l5 5 5-5z'/%3E%3C/svg%3E");
            background-repeat:no-repeat;
            background-position:right 12px center;
            padding-right:36px;
        }

        #sortType:hover{
            border-color:#0d6efd;
        }

        #sortType:focus{
            border-color:#0d6efd;
            box-shadow:0 0 0 3px rgba(13,110,253,.15);
        }

        .level-badges{
            display:flex;
            flex-wrap:wrap;
            gap:8px;
            margin-bottom:18px;
        }

        .level-badge{
            padding:6px 12px;
            border-radius:18px;
            font-size:13px;
            font-weight:bold;
            color:#fff;
            white-space:nowrap;
        }

        .beginner{
            background:#f1c40f;
        }

        .amateur{
            background:#2196F3;
        }

        .semipro{
            background:#e74c3c;
        }

        .pro{
            background:#8e44ad;
        }

    </style>
</head>
<body>
<div class="header">
    <div class="logo">⚽ PLAB PLABER</div>
</div>

<div class="search-wrap">
    <div class="search-box">

        <div class="item">
            <label>지역</label>
            <select id="region">
                <option value="1">서울</option>
                <option value="2">경기</option>
                <option value="3">인천</option>
                <option value="4">대전/세종</option>
                <option value="5">대구</option>
                <option value="6">부산</option>
                <option value="7">광주</option>
                <option value="8">제주</option>
            </select>
        </div>


        <div class="item">
            <label>날짜</label>
            <select id="qDate">
                <option value="0"></option>
                <option value="1"></option>
                <option value="2"></option>
                <option value="3"></option>
                <option value="4"></option>
                <option value="5"></option>
                <option value="6"></option>
            </select>
        </div>


        <div class="item">
            <label>최소 확정인원</label>
            <select id="people">
                <option value="1">1명</option>
                <option value="2">2명</option>
                <option value="3">3명</option>
                <option value="4">4명</option>
                <option value="5">5명</option>
                <option value="6">6명</option>
                <option value="7">7명</option>
                <option value="8">8명</option>
                <option value="9">9명</option>
                <option value="10">10명</option>
                <option value="11">11명</option>
                <option value="12">12명</option>
                <option value="13">13명</option>
                <option value="14">14명</option>
                <option value="15">15명</option>
                <option value="16">16명</option>
                <option value="17">17명</option>
            </select>
        </div>


        <div class="item">
            <label>최대 평균레벨</label>
            <select id="level">
                <option value="2.2"></option>
                <option value="2.3"></option>
                <option value="2.4"></option>
                <option value="2.5"></option>
                <option value="2.6"></option>
                <option value="2.7"></option>
                <option value="2.8"></option>
                <option value="2.9"></option>
                <option value="3.0"></option>
                <option value="5.0"></option>
            </select>
        </div>

        <div class="btn-area">
            <button type="button" class="search-btn" onclick="searchMatch()">검색</button>
        </div>

    </div>
</div>


<div class="content">

    <div class="result-header">

        <div class="total">
            검색 결과 <b id="resultCount">0</b>건
        </div>

        <select id="sortType" disabled>
            <option value="" selected disabled>정렬 선택</option>
            <option value="default">📅 날짜순</option>
            <option value="woman">👩 여자 플래버순</option>
            <option value="levelAsc">📉 평균 레벨 낮은순</option>
            <option value="levelDesc">📈 평균 레벨 높은순</option>
        </select>

    </div>

    <div id="match-list" class="match-list">
        <div class="empty-box">
            <div class="empty-icon">⚽</div>
            <div class="empty-title">검색 조건을 입력해주세요.</div>
            <div class="empty-desc">검색 버튼을 눌러 매치를 조회합니다.</div>
        </div>
    </div>
</div>

<%-- mask --%>
<div id="loading-mask" class="loading-mask" style="display:none;">
    <div class="loading-box">
        <div class="spinner"></div>
        <div class="loading-text">데이터 조회중입니다...</div>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>

    var matchList = []; // 결과 전역
    var originMatchList = []; // 기본순 전역

    $(document).ready(function () {
        setDateOptions();
        setLevelOptions();

        $("#sortType").val("").trigger("change");

        // sort
        $("#sortType").change(function () {

            var sortType = $(this).val();

            switch (sortType) {

                case "default":
                    matchList = originMatchList.slice();
                    break;

                case "woman":
                    matchList.sort(function(a, b) {
                        return (b.WOMAN_COUNT || 0) - (a.WOMAN_COUNT || 0);
                    });
                    break;

                case "levelAsc":
                    matchList.sort(function(a, b) {
                        return a.AVG_LEVEL - b.AVG_LEVEL;
                    });
                    break;

                case "levelDesc":
                    matchList.sort(function(a, b) {
                        return b.AVG_LEVEL - a.AVG_LEVEL;
                    });
                    break;
            }

            renderMatchList(matchList);
        });

    });

    // html set date
    function setDateOptions() {

        var today = new Date();
        var week = ["일", "월", "화", "수", "목", "금", "토"];

        $("#qDate option").each(function () {

            var offset = parseInt($(this).val(), 10);

            var date = new Date(today);
            date.setDate(today.getDate() + offset);

            var yyyy = date.getFullYear();
            var mm = ("0" + (date.getMonth() + 1)).slice(-2);
            var dd = ("0" + date.getDate()).slice(-2);
            var day = week[date.getDay()];

            $(this).text(yyyy + "-" + mm + "-" + dd + "(" + day + ")");
        });
    }

    // html set level
    function setLevelOptions() {

        var labels = {
            "2.2": "아마2 이하",
            "2.3": "아마2",
            "2.4": "아마2.5",
            "2.5": "아마3",
            "2.6": "아마3.5",
            "2.7": "아마4",
            "2.8": "아마4.5",
            "2.9": "아마5",
            "3.0": "아마5.5",
            "5.0": "제한 없음"
        };

        $("#level option").each(function () {

            var value = $(this).val();

            if (labels[value]) {
                $(this).text(labels[value]);
            }

        });
    }


    function searchMatch(){

        $.ajax({
            url:"PlabServlet",
            type:"GET",
            dataType:"json",
            data:{
                region:$("#region").val(),
                people:$("#people").val(),
                level:$("#level").val(),
                qDate:$("#qDate").val(),
                womanOnly:$("#womanOnly").val()
            },

            beforeSend:function(){
                showLoading();
            },

            success:function(result){
                renderMatchList(result);

                originMatchList = result.slice(); // 원본 보관용 ( 날짜순 )
                matchList = result.slice();       // 화면 정렬을 위한 랜더링용

                $("#sortType").prop("disabled", false).val("default").trigger("change");
            },

            error:function(xhr){
                console.log(xhr.responseText);

                $("#match-list").html(
                    '<div class="empty-box">' +
                    '<div class="empty-icon">⚠️</div>' +
                    '<div class="empty-title">서버 오류</div>' +
                    '<div class="empty-desc">서버 오류가 발생했습니다.</div>' +
                    '</div>'
                );
            },
            complete:function(){
                hideLoading();
            }
        });
    }

    function renderMatchList(list) {

        $("#resultCount").text(list.length);

        if (!list || list.length === 0) {

            $("#match-list").html(
                '<div class="empty-box">' +
                '<div class="empty-icon">🔍</div>' +
                '<div class="empty-title">조회 실패</div>' +
                '<div class="empty-desc">조회 조건에 맞는 매치 정보가 없습니다.</div>' +
                '</div>'
            );
            return;
        }

        var html = "";

        $.each(list, function (index, item) {

            var womanCount = item.WOMAN_COUNT || 0;
            var womanClass = womanCount > 0 ? " woman-match" : "";

            // 여자 플래버 배지
            var womanBadge = "";

            if (womanCount > 0) {
                womanBadge =
                    '<div class="woman-badge">' +
                    '여자 플래버 ' + womanCount + '명' +
                    '</div>';
            }


            // 아마2 이하 경기 배지
            var lowLevelBadge = "";

            if (item.AVG_LEVEL < 2.3) {
                lowLevelBadge =
                    '<div class="low-level-badge">' +
                    '평균 아마2 이하' +
                    '</div>';
            }

            html +=
                '<div class="match-card' + womanClass + '">' +

                '<div class="card-header">' +

                '<div>' +

                '<div class="stadium">' +
                item.MATCH_STADIUM +
                '</div>' +

                '<div class="schedule">' +
                '📅 ' + formatSchedule(item.SCHEDULE) +
                '</div>' +

                '</div>' +

                '<div class="badge-wrap">' +
                lowLevelBadge +
                womanBadge +
                '</div>' +

                '</div>' +

                '<div class="card-body">' +

                '<div class="level-badges">' +
                makeLevelBadges(item) +
                '</div>' +

                '<div class="summary">' +

                '<div class="summary-item">' +
                '<div class="title">평균 레벨</div>' +
                '<div class="value">' +
                (Math.round(item.AVG_LEVEL * 100) / 100) +
                ' (' + getLevelName(item.AVG_LEVEL) + ')' +
                '</div>' +
                '</div>' +

                '<div class="summary-item">' +
                '<div class="title">확정 인원 [ROOKIE 포함]</div>' +
                '<div class="value">' +
                item.CONFIRM_COUNT + '명' +
                '</div>' +
                '</div>' +

                '<div class="summary-item">' +
                '<div class="title">ROOKIE 인원</div>' +
                '<div class="value">' +
                item["ROOKIE[BATCH]"] + '명' +
                '</div>' +
                '</div>' +

                '<div class="summary-item">' +
                '<div class="title">Match ID</div>' +
                '<div class="value">' +
                '<a href="https://www.plabfootball.com/match/' +
                item.MATCH_ID +
                '" target="_blank" class="match-link">' +
                '🔗 ' + item.MATCH_ID +
                '</a>' +
                '</div>' +
                '</div>' +

                '</div>' +

                '</div>' +

                '</div>';

        });

        $("#match-list").html(html);

    }


    function getLevelName(avgLevel) {

        var level = Math.floor(avgLevel * 10) / 10;

        if (level <= 2.2) {
            return "아마2 이하";
        }

        if (level >= 3.0) {
            return "세미1 이상";
        }

        var levelMap = {
            "2.3": "아마2",
            "2.4": "아마2.5",
            "2.5": "아마3",
            "2.6": "아마3.5",
            "2.7": "아마4",
            "2.8": "아마4.5",
            "2.9": "아마5",
            "3.0": "아마5.5"
        };

        return levelMap[level.toFixed(1)] || "-";
    }

    function formatSchedule(schedule) {

        var date = new Date(schedule);

        var week = ["일", "월", "화", "수", "목", "금", "토"];

        var yyyy = date.getFullYear();
        var mm = ("0" + (date.getMonth() + 1)).slice(-2);
        var dd = ("0" + date.getDate()).slice(-2);

        var hh = ("0" + date.getHours()).slice(-2);
        var mi = ("0" + date.getMinutes()).slice(-2);

        return yyyy + "-" + mm + "-" + dd +
            "(" + week[date.getDay()] + ") " +
            hh + ":" + mi;
    }

    function showLoading(){
        $("#loading-mask").css("display","flex");
    }

    function hideLoading(){
        $("#loading-mask").hide();
    }

    function makeLevelBadges(item){

        var html = "";

        var badges = [
            {key:"BGN[1]", text:"BGN[1]  ", cls:"beginner"},
            {key:"BGN[2]", text:"BGN[2]  ", cls:"beginner"},
            {key:"BGN[3]", text:"BGN[3]  ", cls:"beginner"},

            {key:"AMA[1]", text:"AMA[1]  ", cls:"amateur"},
            {key:"AMA[2]", text:"AMA[2]  ", cls:"amateur"},
            {key:"AMA[3]", text:"AMA[3]  ", cls:"amateur"},
            {key:"AMA[4]", text:"AMA[4]  ", cls:"amateur"},
            {key:"AMA[5]", text:"AMA[5]  ", cls:"amateur"},

            {key:"SEM[1]", text:"SEM[1]  ", cls:"semipro"},
            {key:"SEM[2]", text:"SEM[2]  ", cls:"semipro"},
            {key:"SEM[3]", text:"SEM[3]  ", cls:"semipro"},

            {key:"PRO", text:"PRO  ", cls:"pro"}
        ];

        $.each(badges,function(i,b){

            var cnt = item[b.key] || 0;

            if(cnt > 0){

                html +=
                    '<div class="level-badge '+b.cls+'">' +
                    b.text + ' ' + cnt + '명' +
                    '</div>';
            }

        });

        return html;
    }



</script>


</body>
</html>