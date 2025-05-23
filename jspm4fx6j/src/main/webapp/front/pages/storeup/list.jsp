<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<!-- 收藏 -->
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<title>收藏</title>
		<link rel="stylesheet" href="../../layui/css/layui.css">
		<!-- 样式 -->
		<link rel="stylesheet" href="../../css/style.css" />
		<!-- 主题（主要颜色设置） -->
		<link rel="stylesheet" href="../../css/theme.css" />
		<!-- 通用的css -->
		<link rel="stylesheet" href="../../css/common.css" />
	</head>
	<style>
		#swiper {
			overflow: hidden;
		}
		#swiper .layui-carousel-ind li {
			width: 16px;
			height: 8px;
			border-width: 0;
			border-style: solid;
			border-color: rgba(0, 0, 0, 0.5);
			border-radius: 4px;
			background-color: #f7f7f7;
			box-shadow: 0 0 0px 4px rgba(0, 0, 0, 0.5);
		}
		#swiper .layui-carousel-ind li.layui-this {
			width: 34px;
			height: 8px;
			border-width: 0;
			border-style: solid;
			border-color: rgba(0,0,0,.3);
			border-radius: 4px;
			background-color: rgba(252, 241, 211, 1);
			box-shadow: 0 0 0px 4px rgba(0, 0, 0, 0.5);
		}
		
		.index-title {
		    text-align: center;
		    box-sizing: border-box;
		    width: 980px;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    flex-direction: column;
		}
		
		.layui-laypage .layui-laypage-count {
		  padding: 0 10px;
		}
		.layui-laypage .layui-laypage-skip {
		  padding-left: 10px;
		}
	</style>
	<body>

		<div id="app">
			<!-- 轮播图 -->
			<div class="layui-carousel" id="swiper" :style='{"boxShadow":"0 0 0px rgba(110,22,64,.8)","margin":"0 auto","borderColor":"rgba(0,0,0,.3)","borderRadius":"0","borderWidth":"0","width":"100%","borderStyle":"solid"}'>
			  <div carousel-item id="swiper-item">
				<div v-for="(item,index) in swiperList" :key="index">
					<img style="width: 100%;height: 100%;object-fit:cover;" :src="item.img" />
				</div>
			  </div>
			</div>
			<!-- 轮播图 -->
			
			<!-- 标题 -->
			<div class="index-title" :style='{"padding":"4px","boxShadow":"0 0 0px rgba(110,22,64,.8)","margin":"10px auto","borderColor":"rgba(0,0,0,.3)","backgroundColor":"rgba(209, 202, 184, 1)","color":"rgba(255, 255, 255, 1)","borderRadius":"4px","borderWidth":"0","fontSize":"20px","borderStyle":"solid","height":"auto"}'>
			  <span>USER / STOREUP</span><span>我的收藏</span>
			</div>
			<!-- 标题 -->

			<!-- 图文列表 -->
			<div class="data-container layui-row">
				<fieldset class="search-container">
					<form class="layui-form">
						<div class="layui-inline" style="margin-bottom: 10px;">
							<label class="layui-form-label">名称</label>
							<div class="layui-input-inline">
								<input type="text" name="name" id="name" placeholder="名称" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-inline" style="margin-left: 30px;margin-bottom: 10px;">
							<button id="btn-search" type="button" class="layui-btn">
								<i class="layui-icon layui-icon-search"></i> 搜索
							</button>
						</div>
					</form>
				</fieldset>
				<div class="data-list layui-col-md8 layui-col-md-offset2">
					<div @click="jump('../'+item.tablename+'/detail.jsp?id='+item.refid)" v-for="(item,index) in dataList" v-bind:key="index"
					 class="data-item layui-col-md3">
						<img class="cover" :src="baseurl+item.picture">
						<h3 class="title">{{item.name}}</h3>
					</div>
				</div>
				<div class="pager" id="pager" :style="{textAlign:2==1?'left':2==2?'center':'right'}"></div>
			</div>
			<!-- 图文列表 -->
		</div>


		<!-- layui -->
		<script src="../../layui/layui.js"></script>
		<!-- vue -->
		<script src="../../js/vue.js"></script>
		<!-- 组件配置信息 -->
		<script src="../../js/config.js"></script>
		<!-- 扩展插件配置信息 -->
		<script src="../../modules/config.js"></script>
		<!-- 工具方法 -->
		<script src="../../js/utils.js"></script>
		<script>
			var vue = new Vue({
				el: '#app',
				data: {
					// 轮播图
					swiperList: [{
						img: '../../img/banner.jpg'
					}],
					baseurl: '',
					dataList: []
				},
				filters: {
					newsDesc: function(val) {
						if (val) {
							if (val.length > 200) {
								return val.substring(0, 200).replace(/<[^>]*>/g).replace(/undefined/g, '');
							} else {
								return val.replace(/<[^>]*>/g).replace(/undefined/g, '');
							}
						}
						return '';
					}
				},
				methods: {
					jump(url) {
						jump(url)
					}
				}
			})

			layui.use(['layer', 'element', 'carousel', 'laypage', 'http', 'jquery'], function() {
				var layer = layui.layer;
				var element = layui.element;
				var carousel = layui.carousel;
				var laypage = layui.laypage;
				var http = layui.http;
				var jquery = layui.jquery;

				var limit = 8;
				vue.baseurl = http.baseurl;

				// 获取轮播图 数据
				http.request('config/list', 'get', {
					page: 1,
					limit: 5
				}, function(res) {
					if (res.data.list.length > 0) {
						var swiperItemHtml = '';
						for (let item of res.data.list) {
							if (item.name.indexOf('picture') >= 0 && item.value && item.value != "" && item.value != null) {
								swiperItemHtml +=
									'<div>' +
									'<img class="swiper-item" style="width: 100%;height: 100%;object-fit:cover;" src="' + http.baseurl+item.value + '">' +
									'</div>';
							}
						}
						jquery('#swiper-item').html(swiperItemHtml);
						// 轮播图
						vue.$nextTick(() => {
						  carousel.render({
						  	elem: '#swiper',
							width: '100%',
						  	height: '320px',
						  	arrow: 'hover',
						  	anim: 'default',
						  	autoplay: 'true',
						  	interval: '3000',
						  	indicator: 'inside'
						  });
						
						})
					}
				});
				// 分页列表
				pageList();

				// 搜索按钮
				jquery('#btn-search').click(function(e) {
					pageList();
				});

				function pageList() {
					var param = {
						page: 1,
						limit: limit,
						type: 1,
						userid: localStorage.getItem('userid')
					}
					if (jquery('#name').val()) {
						param['name'] = jquery('#name').val() ? '%' + jquery('#name').val() + '%' : '';
					}
					// 获取列表数据
					http.request('storeup/list', 'get', param, function(res) {
						vue.dataList = res.data.list
						// 分页
						laypage.render({
							elem: 'pager',
							count: res.data.total,
							limit: limit,
							groups: 5,
							layout: ["prev","page","next"],
							theme: '#D1CAB8',
							jump: function(obj, first) {
								//首次不执行
								if (!first) {
									http.request('storeup/list', 'get', param, function(res) {
										vue.dataList = res.data.list
									})
								}
							}
						});
					})
				}
			});
		</script>
	</body>
</html>
