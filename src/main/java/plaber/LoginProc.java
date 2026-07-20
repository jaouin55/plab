package plaber;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/loginProc")
public class LoginProc extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String result = "FAIL";
        String message = "";

        try {

            String userId = request.getParameter("userId");
            String password = request.getParameter("password");

            if (userId == null || userId.trim().isEmpty()) {

                message = "아이디를 입력해주세요.";

            } else if (password == null || password.trim().isEmpty()) {

                message = "비밀번호를 입력해주세요.";

            } else {

                if ("jaouin55".equals(userId) && "!jaouin55".equals(password)) {

                    HttpSession session = request.getSession();

                    session.setAttribute("LOGIN", true);
                    session.setAttribute("LOGIN_USER_ID", userId);
                    session.setMaxInactiveInterval(60 * 30);

                    result = "SUCCESS";
                    message = "로그인 성공";

                } else {

                    message = "아이디 또는 비밀번호가 올바르지 않습니다.";

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

            result = "ERROR";
            message = "시스템 오류가 발생했습니다.";

        }

        String json =
                "{"
                        + "\"result\":\"" + escape(result) + "\","
                        + "\"message\":\"" + escape(message) + "\""
                        + "}";

        response.getWriter().write(json);
        response.getWriter().flush();

    }

    /**
     * JSON 문자열 Escape
     */
    private String escape(String str) {

        if (str == null) {
            return "";
        }

        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "")
                .replace("\n", "");

    }

}
