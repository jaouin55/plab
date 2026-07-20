package plaber;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Optional;

@WebServlet("/PlabServlet")
public class PlabService extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        int region  = Integer.parseInt(request.getParameter("region"));
        int people  = Integer.parseInt(request.getParameter("people"));
        float level = Float.parseFloat(request.getParameter("level"));
        int qDate   = Integer.parseInt(request.getParameter("qDate"));

        PlabService service = new PlabService();

        ArrayList<HashMap<String,Object>> list = service.search(region, people, level, qDate);

        ObjectMapper mapper = new ObjectMapper();

        response.setContentType("application/json;charset=UTF-8");

        mapper.writeValue(response.getWriter(), list);
    }

    public ArrayList<String> matchGetId(int q_date , int region) {

        ArrayList<String> ids = new ArrayList<>();

        LocalDate today = LocalDate.now();  // 오늘 날짜
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        ObjectMapper mapper = new ObjectMapper();

        for (int q = q_date; q < (q_date + 1); q++) {


            LocalDate targetDate = today.plusDays(q);
            String dateStr = targetDate.format(formatter);

            String baseUri = "https://www.plabfootball.com/api/v2/integrated-matches/?ordering=schedule&hide_soldout=&region="
                    + region + "&sch=" + dateStr;

            try {

                for (int r = 1; r < 20; r++) {

                    String uri = baseUri + "&page=" + r;

                    URL url = new URL(uri);
                    HttpURLConnection con = (HttpsURLConnection) url.openConnection();
                    con.setRequestMethod("GET");
                    con.setRequestProperty("Accept", "application/json");
                    con.setConnectTimeout(10000);
                    con.setReadTimeout(10000);

                    int responseCode = con.getResponseCode();
                    if (responseCode == HttpsURLConnection.HTTP_OK) {
                        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
                        StringBuilder response = new StringBuilder();
                        String inputLine;
                        while ((inputLine = in.readLine()) != null) {
                            response.append(inputLine);
                        }
                        in.close();

                        // JSON 파싱 (Jackson)
                        JsonNode root = mapper.readTree(response.toString());
                        JsonNode results = root.path("results");
                        if (results.isArray()) {
                            for (JsonNode item : results) {
                                ids.add(item.path("id").asText());
                            }
                        }
                    } else {
                        System.out.println("GET 요청 실패 : " + responseCode);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return ids;
    }




    private ArrayList<HashMap<String,Object>> getMatchList(int q_date , int people , int region, float wantMatchLevel) {

        ArrayList<String> ids = matchGetId(q_date , region);

        String uri = "https://www.plabfootball.com/api/v2/matches/";

        ArrayList<HashMap<String, Object>> list =
                new ArrayList<HashMap<String, Object>>();

        ArrayList<HashMap<String, Object>> avgList =
                new ArrayList<HashMap<String, Object>>();

        int listIdx = 0;
        int avgIdx = 0;

        try {

            for (int idx = 0; idx < ids.size(); idx++) {

                int matchParam = Integer.parseInt(ids.get(idx));

                int userSexCount   = 0;
                String label_title = "";
                String dateFormat  = "";

                String targetUrl = uri + matchParam;

                URL url = new URL(targetUrl);

                HttpURLConnection conn = (HttpsURLConnection) url.openConnection();

                conn.setRequestMethod("GET");
                conn.setRequestProperty("Accept", "application/json");
                conn.setConnectTimeout(10000);
                conn.setReadTimeout(10000);

                int responseCode = conn.getResponseCode();

                if (responseCode != 200) {
                    conn.disconnect();
                    continue;
                }

                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));

                StringBuilder response = new StringBuilder();

                String line;

                while ((line = br.readLine()) != null) {
                    response.append(line);
                }

                ObjectMapper mapper = new ObjectMapper();

                JsonNode root = mapper.readTree(response.toString());

                int sexValue = root.path("sex").asInt();

                if (sexValue == -1) {
                    conn.disconnect();
                    continue;
                }

                String scheduleStr = root.path("schedule").asText();

                if (scheduleStr == null || scheduleStr.length() == 0) {
                    conn.disconnect();
                    continue;
                }

                ZonedDateTime schedule = ZonedDateTime.parse(scheduleStr, DateTimeFormatter.ISO_OFFSET_DATE_TIME);

                ZonedDateTime now = ZonedDateTime.now();

                if (!schedule.isAfter(now)) {
                    conn.disconnect();
                    continue;
                }

                for (JsonNode apply : root.path("applys")) {

                    if (apply.has("user_sex")
                            && apply.get("user_sex").asInt() == -1
                            && "CONFIRM".equals(apply.path("status").asText())) {

                        userSexCount++;
                    }
                }

                label_title = root.path("label_title").asText();
                dateFormat = root.path("schedule").asText();

                int rows = root.path("confirm_cnt").asInt();

                int total = 0;
                int rookies = 0;
                double levels = 0;

                int b1 = 0;
                int b2 = 0;
                int b3 = 0;

                int a1 = 0;
                int a2 = 0;
                int a3 = 0;
                int a4 = 0;
                int a5 = 0;

                int s1 = 0;
                int s2 = 0;
                int s3 = 0;

                int p = 0;

                if (rows >= people && rows < 18) {

                    for (JsonNode apply : root.path("applys")) {

                        if (!"CONFIRM".equals(apply.path("status").asText())) {
                            continue;
                        }

                        double lvl = apply.path("level").asDouble(-1);

                        if (lvl > 0) {
                            levels += lvl;
                            total++;
                        } else {
                            rookies++;
                        }

                        JsonNode profileLevel = apply.path("profile_level");

                        String tier = profileLevel.path("tier").asText();
                        int grade = profileLevel.path("grade").asInt();

                        if ("BEGINNER".equals(tier)) {

                            if (grade == 1) b1++;
                            else if (grade == 2) b2++;
                            else if (grade == 3) b3++;

                        } else if ("AMATEUR".equals(tier)) {

                            if (grade == 1) a1++;
                            else if (grade == 2) a2++;
                            else if (grade == 3) a3++;
                            else if (grade == 4) a4++;
                            else if (grade == 5) a5++;

                        } else if ("SEMIPRO".equals(tier)) {

                            if (grade == 1) s1++;
                            else if (grade == 2) s2++;
                            else if (grade == 3) s3++;

                        } else if ("PRO".equals(tier)) {

                            p++;

                        }

                    }

                    if (levels > 0) {

                        double result = levels / total;

                        if (result < wantMatchLevel) {

                            HashMap<String, Object> map =
                                    new LinkedHashMap<String, Object>();

                            map.put("MATCH_ID", matchParam);
                            map.put("SCHEDULE", dateFormat);
                            map.put("MATCH_STADIUM", label_title);
                            map.put("AVG_LEVEL", result);
                            map.put("CONFIRM_COUNT", total + rookies);
                            map.put("ROOKIE[BATCH]", rookies);

                            map.put("BGN[1]", b1);
                            map.put("BGN[2]", b2);
                            map.put("BGN[3]", b3);

                            map.put("AMA[1]", a1);
                            map.put("AMA[2]", a2);
                            map.put("AMA[3]", a3);
                            map.put("AMA[4]", a4);
                            map.put("AMA[5]", a5);

                            map.put("SEM[1]", s1);
                            map.put("SEM[2]", s2);
                            map.put("SEM[3]", s3);

                            map.put("PRO", p);

                            map.put("WOMAN_COUNT", userSexCount);

                            avgList.add(avgIdx++, map);

                        }

                    }

                }

                // this is woman match list
                /* if (userSexCount > 0) {

                    HashMap<String, Object> map =
                            new LinkedHashMap<String, Object>();

                    map.put("MATCH_ID", matchParam);
                    map.put("SCHEDULE", dateFormat);
                    map.put("MATCH_STADIUM", label_title);
                    map.put("WOMAN_COUNT", userSexCount);

                    list.add(listIdx++, map);
                }*/

                br.close();
                conn.disconnect();

            } // for(ids)

        } catch (Exception e) {
            e.printStackTrace();
        }

        return avgList;

    }


    // main.jsp 호출용
    public ArrayList<HashMap<String,Object>> search(
            int region,
            int people,
            float wantMatchLevel,
            int q_Date){

        return getMatchList(q_Date , people , region , wantMatchLevel);
    }


}
