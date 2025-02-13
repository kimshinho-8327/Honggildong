library(rvest)
library(ggplot2)

# url추출 및 html 읽어들이기
# url정보 : 프리미어 리그 공식 홈페이지
url <- "https://www.premierleague.com/tables"
html <- read_html(url)

# 프리미어리그 팀 이름 추출하여 저장
team_name <- html_nodes(html, "span.long")[1:19] %>% html_text()
team_name

# 프리미어리그 승점 추출하여 저장
team_point <- html_nodes(html, "td.points")[1:19] %>% html_text()

# 불러온 프리미어리그 승점은 문자형이므로 타입변환으로 int형으로 변환시킨다.
team_point <- as.integer(team_point)
team_point

# 위에서 수집된 팀이름과 승점 paste()함수로 합친뒤 "team_name_point"변수에 저장
team_name_point = paste(c(1:19),"등", team_name , "-", team_point,"점")
team_name_point

# 팀이름과 승점을 데이터프레임 형태로 "premier_league" 변수에 저장
# 승점이 동일한데 순위가 다른 경우에는 프리미어 리그 홈페이지 자체에서 골득실. 승률등 다른 요소가 부합되어 매겨진것
# 이므로 같은 승점이라도 순위에 차이가 발생 
premier_league <- data.frame(team_name = team_name, team_point = team_point)
premier_league

# ggplot 
# ggplot() 사용 / 데이터 프레임 형태의 "premier_league"를 막대그래프 형태로 출력 하며 
# 그래프의 테두리 색깔은 "team_name"을 기준으로 다르게 한다. 
# 막대 그래프 형태로 출력하기 위해 "geom_bar()" 함수의 "stat = identity"로 설정한다.
# 로그 스케일의 축(scale_y_log10)을 사용하여 데이터 간의 상대적인 차이를 시각적으로 보기편하도록 설정하였다.
# 가로축으로 막대그래프를 표시할 경우 x축의 글자가 겹치므로 "coord_flip()"을 사용해 가로축과 세로축의 위치를 바꾸었다.
# reorder()를 사용하여 승점을 오름차순으로 정렬하였다.
# geom_text()를 통해 막대그래프마다 승점현황을 기입하였다.(색깔은 흰색, size = 4)
# lab() 함수를 사용하여 x축과 y축의 이름을 지우고 title의 이름을 새로 기입하였다.
premier_league %>% ggplot(aes(x=reorder(team_name_point, -team_point),y=team_point, fill=team_name, col = team_name)) + geom_bar(stat = "identity") + scale_y_log10() + coord_flip() + geom_text(aes(label=team_point), size=4, hjust=1.25, color='#FFFFFF') + labs(x='',y='', title = "2020-2021 프리미어리그 승점현황")
