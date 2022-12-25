#### Load the required packages ####
# if packages are not installed already,
# install them using function install.packages(" ")

library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(DT)  # for DT tables
library(dplyr)  # for pipe operator & data manipulations
library(plotly) # for data visualization and plots using plotly 
library(ggplot2) # for data visualization & plots using ggplot2
library(ggtext) # beautifying text on top of ggplot
library(maps) # for USA states map - boundaries used by ggplot for mapping
library(ggcorrplot) # for correlation plot
library(shinycssloaders) # to add a loader while graph is populating

#### Thao tác tập dữ liệu ####
# Bộ dữ liệu USArrests đi kèm với cơ sở R
# bạn có thể xem dữ liệu bằng cách đơn giản
# USArrests # bỏ ghi chú nếu chạy cái này

## tạo một đối tượng trạng thái từ rownames 
states = rownames(USArrests)

## Thêm trạng thái biến cột mới vào tập dữ liệu. 
#Điều này sẽ được sử dụng sau này để hợp nhất tập dữ liệu với dữ liệu bản đồ của các tiểu bang Hoa Kỳ
my_data <- USArrests %>% 
  mutate(State = states) 

# Tên cột không có trạng thái. Điều này sẽ được sử dụng trong selectinput cho các lựa chọn trong Shinydashboard
c1 = my_data %>% 
  select(-"State") %>% 
  names()

# Tên cột không có trạng thái và UrbanPopulation. Điều này sẽ được sử dụng trong selectinput cho các lựa chọn trong Shinydashboard
c2 = my_data %>% 
  select(-"State", -"UrbanPop") %>% 
  names()

####Chuẩn bị dữ liệu cho Bản đồ bắt giữ ####
# dữ liệu bản đồ cho ranh giới các bang của Hoa Kỳ bằng gói bản đồ
# map_data từ gói ggplot
# map_data() chuyển đổi dữ liệu từ gói bản đồ thành một khung dữ liệu có thể được sử dụng thêm để lập bản đồ

state_map <- map_data("state") # trạng thái từ gói bản đồ chứa thông tin cần thiết để tạo ranh giới tiểu bang Hoa Kỳ
# state_map %>% str() # bạn có thể thấy rằng state_map có một cột khu vực. cột vùng có tên tiểu bang của Hoa Kỳ nhưng viết thường


# chuyển đổi trạng thái thành chữ thường
my_data1 = my_data %>% 
  mutate(State = tolower(State))  # chuyển đổi tên tiểu bang từ tập dữ liệu USArrests thành chữ thường để sau này chúng tôi có thể hợp nhất dữ liệu bản đồ vào tập dữ liệu của mình


## Thêm vĩ độ, kinh độ và thông tin khác cần thiết để vẽ đa giác cho bản đồ trạng thái
# Đối với ranh giới tiểu bang có sẵn - thêm thông tin USAArrests.
# Lưu ý rằng ranh giới Alaska và Hawaii không có sẵn, những hàng đó sẽ bị bỏ qua trong dữ liệu được hợp nhất
# right_join từ gói dplyr
merged =right_join(my_data1, state_map,  by=c("State" = "region"))

# Thêm tên viết tắt của bang và vị trí trung tâm của mỗi bang. Tạo một khung dữ liệu từ nó
st = data.frame(abb = state.abb, stname=tolower(state.name), x=state.center$x, y=state.center$y)

# Tham gia các chữ viết tắt trạng thái và vị trí trung tâm vào tập dữ liệu cho từng quan sát trong tập dữ liệu được hợp nhất
# left_join từ gói dplyr
# không có chữ viết tắt nào cho Đặc khu Columbia và do đó những hàng đó sẽ bị loại bỏ trong kết quả
new_join = left_join(merged, st, by=c("State" = "stname"))








