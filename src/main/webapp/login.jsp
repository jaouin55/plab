<%--
  Created by IntelliJ IDEA.
  User: OhSeongKyu
  Date: 26. 7. 20.
  Time: 오전 9:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLAB MATCH - Login</title>

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:'Segoe UI','Malgun Gothic',sans-serif;
        }

        html,
        body{
            width:100%;
            min-height:100%;
        }

        body{
            min-height:100vh;
            display:flex;
            justify-content:center;
            align-items:center;

            padding:20px;

            background:
                    linear-gradient(
                            135deg,
                            #333 0%,
                            #333 45%,
                            #f4f6f9 45%,
                            #f4f6f9 100%
                    );

            overflow-x:hidden;
        }


        .login-card{

            width:min(430px, 100%);

            background:white;

            border-radius:22px;

            padding:45px;

            box-shadow:
                    0 20px 45px rgba(0,0,0,.12);

        }


        .logo{
            font-size:34px;
            font-weight:bold;
            color:#333333;
            text-align:center;
        }


        .subtitle{

            margin-top:10px;
            margin-bottom:35px;

            color:#777;

            text-align:center;

            font-size:15px;

        }


        .form-group{

            margin-bottom:22px;

        }


        .form-group label{

            display:block;

            margin-bottom:8px;

            font-size:14px;

            font-weight:bold;

            color:#555;

        }


        .form-group input{

            width:100%;

            height:52px;

            border:1px solid #ddd;

            border-radius:12px;

            padding:0 18px;

            font-size:16px;

            transition:.25s;

        }


        .form-group input:focus{

            outline:none;

            border-color:#ff6b00;

            box-shadow:
                    0 0 0 4px rgba(255,107,0,.15);

        }


        .option{

            display:flex;

            justify-content:space-between;

            align-items:center;

            margin-bottom:28px;

            font-size:14px;

        }


        .option label{

            display:flex;

            align-items:center;

            gap:8px;

        }


        .option input{

            width:16px;
            height:16px;

            accent-color:#333;

        }


        .login-btn{

            width:100%;

            height:54px;

            border:0;

            border-radius:14px;

            background:#333;

            color:white;

            font-size:17px;

            font-weight:bold;

            cursor:pointer;

            transition:.2s;

        }


        .login-btn:hover{

            background:#f4f6f9;
            color:#333333;

            transform:translateY(-2px);

            box-shadow:
                    0 10px 20px rgba(0,0,0,.3);

        }


        .login-btn:disabled{

            opacity:.6;

            cursor:not-allowed;

        }


        .footer{

            margin-top:30px;

            text-align:center;

            color:#999;

            font-size:13px;

        }


        @media(max-width:500px){

            body{

                padding:15px;

                background:
                        linear-gradient(
                                160deg,
                                #ff6b00 0%,
                                #ff8a3d 35%,
                                #f4f6f9 35%
                        );

            }


            .login-card{

                width:100%;

                padding:35px 25px;

                border-radius:18px;

            }


            .logo{

                font-size:28px;

            }


            .subtitle{

                font-size:14px;

                margin-bottom:28px;

            }


            .login-btn{

                height:50px;

                font-size:16px;

            }

        }

    </style>

</head>

<body>

<div class="login-card">

    <div class="logo">
        ⚽ PLAB MATCH
    </div>

    <div class="subtitle">
        로그인 후 원하는 풋살 경기를 찾아보세요.
    </div>

    <form id="loginForm" onsubmit="return false;">

        <div class="form-group">

            <label>아이디</label>

            <input
                    id="userId"
                    name="userId"
                    type="text"
                    placeholder="아이디를 입력하세요">

        </div>

        <div class="form-group">

            <label>비밀번호</label>

            <input
                    id="password"
                    name="password"
                    type="password"
                    placeholder="비밀번호를 입력하세요">

        </div>

        <div class="option">

            <label>
                <input
                        id="rememberId"
                        type="checkbox">
                로그인 유지
            </label>

        </div>

        <button
                type="button"
                id="btnLogin"
                class="login-btn">

            로그인

        </button>

    </form>

    <div class="footer">

        © 2026 PLAB MATCH [ SeongKyuOh ]

    </div>

</div>

</body>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>

    $(function () {
        Login.init();
    });

    const Login = {

        isLoading: false,

        init: function () {

            this.loadRememberId();
            this.bindEvent();

            $("#userId").focus();
        },

        bindEvent: function () {

            const _this = this;

            // 로그인
            $("#btnLogin").on("click", function () {
                _this.login();
            });

            // 회원가입
            /*$("#btnSignup").on("click", function () {
                location.href = "/signup";
            });*/

            // 비밀번호 찾기
           /* $("#btnFindPassword").on("click", function () {
                location.href = "/findPassword";
            });*/

            // Enter 로그인
            $("#userId, #password").on("keydown", function (e) {
                if (e.keyCode == 13) {
                    _this.login();
                }
            });

            // 아이디 저장
            $("#rememberId").on("change", function () {

                if ($(this).is(":checked")) {
                    localStorage.setItem("rememberId", $("#userId").val());
                } else {
                    localStorage.removeItem("rememberId");
                }

            });

            // 아이디 입력시 저장된 값 갱신
            $("#userId").on("keyup", function () {

                if ($("#rememberId").is(":checked")) {
                    localStorage.setItem("rememberId", $(this).val());
                }

            });

            // 비밀번호 보기
           /* $("#btnShowPassword").on("click", function () {

                const pw = $("#password");

                if (pw.attr("type") == "password") {

                    pw.attr("type", "text");
                    $(this).text("숨기기");

                } else {

                    pw.attr("type", "password");
                    $(this).text("보기");

                }

            });*/

        },

        login: function () {

            if (this.isLoading) {
                return;
            }

            const id = $.trim($("#userId").val());
            const pw = $("#password").val();

            if (id == "") {

                alert("아이디를 입력해주세요.");
                $("#userId").focus();
                return;

            }

            if (pw == "") {

                alert("비밀번호를 입력해주세요.");
                $("#password").focus();
                return;

            }

            this.isLoading = true;

            $("#btnLogin")
                .prop("disabled", true)
                .text("로그인 중");

            $.ajax({

                url: "/loginProc",
                type: "POST",
                dataType: "json",

                data: {

                    userId: id,
                    password: pw

                },

                success: function (res) {

                    if (res.result == "SUCCESS") {

                        if ($("#rememberId").is(":checked")) {
                            localStorage.setItem("rememberId", id);
                        } else {
                            localStorage.removeItem("rememberId");
                        }

                        const next = new URLSearchParams(location.search).get("next");

                        if (next) {
                            location.href = decodeURIComponent(next);
                        } else {
                            location.href = "/main.jsp";
                        }

                    } else {

                        alert(res.message || "아이디 또는 비밀번호가 올바르지 않습니다.");

                        $("#password").val("").focus();

                    }

                },

                error: function () {

                    alert("서버와 통신 중 오류가 발생했습니다.");

                },

                complete: function () {

                    Login.isLoading = false;

                    $("#btnLogin")
                        .prop("disabled", false)
                        .text("로그인");

                }

            });

        },

        loadRememberId: function () {

            const rememberId = localStorage.getItem("rememberId");

            if (rememberId != null) {

                $("#userId").val(rememberId);
                $("#rememberId").prop("checked", true);

            }

        }

    };

</script>
</html>
