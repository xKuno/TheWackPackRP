window.addEventListener('message', function (event) {
	var item = event.data;
	if (item.notification){
		if (item.notification_type == "sucesso") {
			vt.successo(item.notification,{
				position: "top-right",
				duration: 8000
			});
		} else if (item.notification_type == "importante") {
			vt.importante(item.notification,{
				position: "top-right",
				duration: 8000
			});
		} else if (item.notification_type == "negado") {
			vt.erro(item.notification,{
				position: "top-right",
				duration: 8000
			});
		}
	} else if (item.price){
	
		$('#modal-confirm-title').empty();
		$('#modal-confirm-title').append(Lang[item.lang]['confim_buy_title']);
		$('#modal-confirm-button').empty();
		$('#modal-confirm-button').append(Lang[item.lang]['confim_buy_confirm_button']);
		$('#modal-cancel-button').empty();
		$('#modal-cancel-button').append(Lang[item.lang]['confim_buy_cancel_button']);
		$('#modal-p').empty();
		$('#modal-p').append(Lang[item.lang]['confim_buy'].format(new Intl.NumberFormat(item.format.location, { style: 'currency', currency: item.format.currency }).format(item.price)));
		$("body").css("display", "");
		$(".main").css("display", "none");
		$(document).ready(function(){
			$("#buyModal").modal({show: true});
		});
	} else if (item.showmenu){
		var config = item.dados.config;
		var gas_station_jobs = item.dados.gas_station_jobs;
		var gas_station_business = item.dados.gas_station_business;
		var gas_station_balance = item.dados.gas_station_balance;

		if(item.update != true){
			$(".pages").css("display", "none");
			$("body").css("display", "");
			$(".main").css("display", "");
			$(".main-page").css("display", "block");
			$('.sidebar-navigation ul li').removeClass('active');
			$('#sidebar-1').addClass('active');
			openPage(0);
		}

		/*
		* STATISTICS PAGE
		*/
		$('#profile-money-earned').empty();
		$('#profile-money-earned').append(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(gas_station_business.total_money_earned));
		$('#profile-money-spent').empty();
		$('#profile-money-spent').append(new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(gas_station_business.total_money_spent));
		$('#profile-goods').empty();
		$('#profile-goods').append(new Intl.NumberFormat(config.format.location).format(gas_station_business.gas_bought) + "L");
		$('#profile-distance-traveled').empty();
		$('#profile-distance-traveled').append(new Intl.NumberFormat(config.format.location).format(gas_station_business.distance_traveled) + 'km');
		$('#profile-total-visits').empty();
		$('#profile-total-visits').append(new Intl.NumberFormat(config.format.location).format(gas_station_business.total_visits));
		$('#profile-customers').empty();
		$('#profile-customers').append(new Intl.NumberFormat(config.format.location).format(gas_station_business.customers));
		var stock_capacity = config.gas_station_types.stock_capacity + config.gas_station_types.upgrades.stock.level_reward[gas_station_business.stock_upgrade];
		var stock_capacity_percent = ((gas_station_business.stock * 100)/stock_capacity).toFixed(1);
		$('#profile-stock-1').empty();
		var str_low_stock = '';
		if(config.warning == 1){
			str_low_stock = '<small class="red"><b>' + Lang[config.lang]['str_low_stock'] + '</b></small>';
		}
		$('#profile-stock-1').append(stock_capacity_percent + '% ' + str_low_stock);
		$('#profile-stock-2').empty();
		$('#profile-stock-2').append(Lang[config.lang]['str_stock_capacity'].format(stock_capacity));
		$('#profile-stock-3').empty();
		$('#profile-stock-3').append('<div class="progress-bar bg-amber accent-4" role="progressbar" style="width: ' + stock_capacity_percent + '%" aria-valuenow="' + stock_capacity_percent + '" aria-valuemin="0" aria-valuemax="100"></div>');
		$('#stock-amount').empty();
		$('#stock-amount').append('(' + gas_station_business.stock_amount + ')');
		$('#stock-products').empty();
		
		/*==================
			FUEL PAGE
		==================*/
		$('#fuel-page').empty();
		$('#fuel-page').append(`
			<div class="col-md-6">
				<div id="fluid-meter-3"></div>
			</div>
			<div class="control-box">
				<div class="slider-content">
					<div class="icon"><i class="fas fa-wallet"></i></div>
					<div class="text">` + Lang[config.lang]['str_gas_price'] +`</div>
					<div class="value">` + gas_station_business.price + `</div>
					<button onclick="applyPrice()" class="btn btn-blue btn-darken-2 btn-send white mt-5 pl-5 pr-5"><i class="fas fa-check"></i>&nbsp;&nbsp;` + Lang[config.lang]['btn_apply_price'] +`</button>
				</div>
				<div class="slider-container">
					<span class="bar"><span class="fill"></span></span>
					<input type="range" id="slider" class="slider" min="` + config.gas_station_types.min_gas_price + `" max="` + (config.gas_station_types.max_gas_price*100) + `" value="` + gas_station_business.price + `">
				</div>
			</div>
		`);
		
		// Fluid meter
		var fm3 = new FluidMeter();
		fm3.init({
			targetContainer: document.getElementById("fluid-meter-3"),
			fillPercentage: stock_capacity_percent,
			options: {
				fontSize: "70px",
				bubbleAmount: (((gas_station_business.stock * 100)/stock_capacity)*2),
				drawPercentageSign: true,
				drawBubbles: false,
				size: 600,
				borderWidth: 19,
				backgroundColor: "#e2e2e2",
				foregroundColor: "#fafafa",
				foregroundFluidLayer: {
					fillStyle: "gold",
					angularSpeed: 30,
					maxAmplitude: 15,
					frequency: 70,
					horizontalSpeed: -40
				},
				backgroundFluidLayer: {
					fillStyle: "yellow",
					angularSpeed: 100,
					maxAmplitude: 4,
					frequency: 100,
					horizontalSpeed: 100
				}
			}
		});

		// Input range
		var controlBox = document.getElementsByClassName("control-box")[0];
		var cbSlider = controlBox.querySelector("input.slider");
		var cbFill = controlBox.querySelector(".bar .fill");
		var cbValue = controlBox.querySelector(".value");
		function setBar() {
			var min = parseInt(cbSlider.getAttribute("min"));
			var max = parseInt(cbSlider.getAttribute("max"));
			var value = parseInt(cbSlider.value);
			var percent = ((value -min) / (max - min)) * 100;

			cbFill.style.height = percent + "%";
			cbValue.innerText = new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency}).format((value/100));
			// cbValue.innerText = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'USD' }).format((value/100));

			if (percent > 0) {
				controlBox.classList.add("on");
			} else {
				controlBox.classList.remove("on");
			}
		}
		cbSlider.addEventListener("input",setBar);
		setBar();

		/*
		* JOBS PAGE
		*/
		$('#job-page-list').empty();
		$('#form_product').empty();
		for (const key in config.gas_station_types.ressuply) {
			var ressuply = config.gas_station_types.ressuply[key];
			var amount = (ressuply.liters + Math.floor(ressuply.liters*(config.gas_station_types.upgrades.truck.level_reward[gas_station_business.truck_upgrade]/100)));
			var import_price = ressuply.price_per_liter_to_import*amount - (ressuply.price_per_liter_to_import*amount * config.gas_station_types.upgrades.relationship.level_reward[gas_station_business.relationship_upgrade])/100;
			var export_price = ressuply.price_per_liter_to_export*amount;
			$('#job-page-list').append(`
				<div class="col-12">
					<div class="card overflow-hidden w-auto">
						<div class="card-content">
							<div class="card-body cleartfix">
								<div class="media align-items-stretch">
									<div class="align-self-center">
										<img class="font-large-2 mr-2 " src="img/` + ressuply.img + `" width="60">
									</div>
									<div class="media-body align-self-center">
										<h4>` + ressuply.name + `</h4>
									</div>
									<div class="d-flex align-self-center">
										<h1 class="text-right">` + new Intl.NumberFormat(config.format.location).format(amount) + ` ` + Lang[config.lang]['str_liters'] + `</h1>
										<button onclick="startJob(1,` + key + `)" class="btn btn-blue btn-darken-2 white ml-3 export-button">` + Lang[config.lang]['btn_import'] + ` ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(import_price) + `</button>
										<button onclick="startJob(2,` + key + `)" class="btn btn-red btn-darken-2 white ml-3 export-button">` + Lang[config.lang]['btn_export'] + ` ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(export_price) + `</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			`);
		}

		/*
		* CONTRACTS PAGE
		*/
		$('#form_amount').empty();
		$('#form_amount').append(`
			<input type="number" min="1" max="` + config.gas_station_types.ressuply_deliveryman.max_amount + `" name="amount" class="form-control" placeholder="` + Lang[config.lang]['str_amount'] + `" required="required" oninput="InvalidMsg(this,1,` + config.gas_station_types.ressuply_deliveryman.max_amount + `);" oninvalid="InvalidMsg(this,1,` + config.gas_station_types.ressuply_deliveryman.max_amount + `);"> 
		`);
		$('#contracts-page-list').empty();
		for (const gas_station_job of gas_station_jobs) {
			var import_price = config.gas_station_types.ressuply_deliveryman.price_per_liter - (config.gas_station_types.ressuply_deliveryman.price_per_liter * config.gas_station_types.upgrades.relationship.level_reward[gas_station_business.relationship_upgrade])/100;
			var total_cost = gas_station_job.reward + import_price*gas_station_job.amount;
			$('#contracts-page-list').append(`
				<li class="d-flex justify-content-between">
					<div class="d-flex flex-row align-items-center"><img class="font-large-2 mr-2 " src="img/combustivel.png" width="30">
						<div class="ml-2">
							<h6 class="mb-0">` + gas_station_job.name + `</h6>
							<div class="d-flex flex-row mt-1 text-black-50 small">
								<div><i class="fas fa-coins"></i><span class="ml-2">` + Lang[config.lang]['str_reward'] + `: ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(gas_station_job.reward) + `</span></div>
								<div class="ml-3"><i class="fas fa-coins"></i><span class="ml-2">` + Lang[config.lang]['str_total_cost'] + `: ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(total_cost) + `</span></div>
								<div class="ml-3"><i class="fas fa-gas-pump"></i><span class="ml-2">` + Lang[config.lang]['str_amount'] + `: ` + gas_station_job.amount + `</span></div>
							</div>
						</div>
					</div>
					<div class="d-flex flex-row align-items-center">
						<button onclick="deleteJob(` + gas_station_job.id + `)" class="btn btn-red btn-accent-4 white">` + Lang[config.lang]['btn_delete_contract'] + `</button>
					</div>
				</li>
			`);
		}

		/*
		* UPGRADES PAGE
		*/
		$('#upgrades-page').empty();
		$('#upgrades-page').append(`
			<div class="col-lg-4 col-md-6 mb-4 mb-lg-0">
				<div class="card rounded shadow-sm border-0">
					<div class="card-body p-4"><img src="https://cdn.discordapp.com/attachments/533398980428693550/804898333192880128/shop.png" alt="" class="img-fluid d-block mx-auto mb-3">
						<h5> <a href="#" class="text-dark">` + Lang[config.lang]['str_stock_capacity_title'] + `</a></h5>
						<p style="height: 65px;" class="small text-muted font-italic">` + Lang[config.lang]['str_stock_capacity_desc'] + `</p>
						<ul class="small text-muted font-italic">
							<li> ` + Lang[config.lang]['str_level'] + ` 1: +` + config.gas_station_types.upgrades.stock.level_reward[1] + ` ` + Lang[config.lang]['str_units'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 2: +` + config.gas_station_types.upgrades.stock.level_reward[2] + ` ` + Lang[config.lang]['str_units'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 3: +` + config.gas_station_types.upgrades.stock.level_reward[3] + ` ` + Lang[config.lang]['str_units'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 4: +` + config.gas_station_types.upgrades.stock.level_reward[4] + ` ` + Lang[config.lang]['str_units'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 5: +` + config.gas_station_types.upgrades.stock.level_reward[5] + ` ` + Lang[config.lang]['str_units'] + `</li>
						</ul>
						<ul class="justify-content-center d-flex list-inline small">
							` + getStarsHTML(gas_station_business.stock_upgrade) + `
						</ul>
						<button onclick="buyUpgrade('stock')" class="btn btn-blue btn-darken-2 white btn-block">` + Lang[config.lang]['btn_buy'] + ` ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(config.gas_station_types.upgrades.stock.price) + `</button>
					</div>
				</div>
			</div>
			
			<div class="col-lg-4 col-md-6 mb-4 mb-lg-0">
				<div class="card rounded shadow-sm border-0">
					<div class="card-body p-4"><img src="https://cdn.discordapp.com/attachments/533398980428693550/804898331159298078/delivery-truck.png" alt="" class="img-fluid d-block mx-auto mb-3">
						<h5> <a href="#" class="text-dark">` + Lang[config.lang]['str_truck_capacity_title'] + `</a></h5>
						<p style="height: 65px;" class="small text-muted font-italic">` + Lang[config.lang]['str_truck_capacity_desc'] + `</p>
						<ul class="small text-muted font-italic">
							<li> ` + Lang[config.lang]['str_level'] + ` 1: +` + config.gas_station_types.upgrades.truck.level_reward[1] + ` % ` + Lang[config.lang]['str_capacity'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 2: +` + config.gas_station_types.upgrades.truck.level_reward[2] + ` % ` + Lang[config.lang]['str_capacity'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 3: +` + config.gas_station_types.upgrades.truck.level_reward[3] + ` % ` + Lang[config.lang]['str_capacity'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 4: +` + config.gas_station_types.upgrades.truck.level_reward[4] + ` % ` + Lang[config.lang]['str_capacity'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 5: +` + config.gas_station_types.upgrades.truck.level_reward[5] + ` % ` + Lang[config.lang]['str_capacity'] + `</li>
						</ul>
						<ul class="justify-content-center d-flex list-inline small">
							` + getStarsHTML(gas_station_business.truck_upgrade) + `
						</ul>
						<button onclick="buyUpgrade('truck')" class="btn btn-blue btn-darken-2 white btn-block">` + Lang[config.lang]['btn_buy'] + ` ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(config.gas_station_types.upgrades.truck.price) + `</button>
					</div>
				</div>
			</div>
			
			<div class="col-lg-4 col-md-6 mb-4 mb-lg-0">
				<div class="card rounded shadow-sm border-0">
					<div class="card-body p-4"><img src="https://cdn.discordapp.com/attachments/533398980428693550/804898332371189780/manager.png" alt="" class="img-fluid d-block mx-auto mb-3">
						<h5> <a href="#" class="text-dark">` + Lang[config.lang]['str_relationship_title'] + `</a></h5>
						<p style="height: 65px;" class="small text-muted font-italic">` + Lang[config.lang]['str_relationship_desc'] + `</p>
						<ul class="small text-muted font-italic">
							<li> ` + Lang[config.lang]['str_level'] + ` 1: ` + config.gas_station_types.upgrades.relationship.level_reward[1] + `% ` + Lang[config.lang]['str_discount'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 2: ` + config.gas_station_types.upgrades.relationship.level_reward[2] + `% ` + Lang[config.lang]['str_discount'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 3: ` + config.gas_station_types.upgrades.relationship.level_reward[3] + `% ` + Lang[config.lang]['str_discount'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 4: ` + config.gas_station_types.upgrades.relationship.level_reward[4] + `% ` + Lang[config.lang]['str_discount'] + `</li>
							<li> ` + Lang[config.lang]['str_level'] + ` 5: ` + config.gas_station_types.upgrades.relationship.level_reward[5] + `% ` + Lang[config.lang]['str_discount'] + `</li>
						</ul>
						<ul class="justify-content-center d-flex list-inline small">
							` + getStarsHTML(gas_station_business.relationship_upgrade) + `
						</ul>
						<button onclick="buyUpgrade('relationship')" class="btn btn-blue btn-darken-2 white btn-block">` + Lang[config.lang]['btn_buy'] + ` ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency, maximumFractionDigits: 0, minimumFractionDigits: 0 }).format(config.gas_station_types.upgrades.relationship.price) + `</button>
					</div>
				</div>
			</div>
		`);

		/*
		* BANK PAGE
		*/
		$('#bank-page-total-money').empty();
		$('#bank-page-total-money').append(Lang[config.lang]['str_bank_page_total_money'] +' <span class="success darken-1">' + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(gas_station_business.money) + '</span>');
		$('#balance-list').empty();
		for (const balance of gas_station_balance) {
			if(balance.income == 0){
				$('#balance-list').append(`
					<li class="d-flex justify-content-between">
						<div class="d-flex flex-row align-items-center"><i class="fa fa-plus-circle checkicon"></i>
							<div class="ml-2">
								<h6 class="mb-0">` + balance.title + `</h6>
								<div class="d-flex flex-row mt-1 text-black-50 small">
									<div><i class="fas fa-coins"></i></i><span class="ml-2">` + Lang[config.lang]['str_price'] + `: ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(balance.amount) + `</span></div>
									<div class="ml-3"><i class="fas fa-calendar-alt"></i></i><span class="ml-2">` + Lang[config.lang]['str_date'] + `: ` + timeConverter(balance.date,config.format.location) + `</span></div>
								</div>
							</div>
						</div>
					</li>
				`);
			}else{
				$('#balance-list').append(`
					<li class="d-flex justify-content-between">
						<div class="d-flex flex-row align-items-center"><i class="fa fa-minus-circle redicon"></i>
							<div class="ml-2">
								<h6 class="mb-0">` + balance.title + `</h6>
								<div class="d-flex flex-row mt-1 text-black-50 small">
									<div><i class="fas fa-coins"></i></i><span class="ml-2">` + Lang[config.lang]['str_price'] + `: ` + new Intl.NumberFormat(config.format.location, { style: 'currency', currency: config.format.currency }).format(balance.amount) + `</span></div>
									<div class="ml-3"><i class="fas fa-calendar-alt"></i></i><span class="ml-2">` + Lang[config.lang]['str_date'] + `: ` + timeConverter(balance.date,config.format.location) + `</span></div>
								</div>
							</div>
						</div>
					</li>
				`);
			}
		}

		/*
		* Lang texts
		*/
		$('#modal-confirm-title-2').empty();
		$('#modal-confirm-title-2').append(Lang[config.lang]['confim_sell_title']);
		$('#modal-p-2').empty();
		$('#modal-p-2').append(Lang[config.lang]['confim_sell_desc']);
		$('#modal-cancel-button-2').empty();
		$('#modal-cancel-button-2').append(Lang[config.lang]['confim_sell_cancel_button']);
		$('#modal-confirm-button-2').empty();
		$('#modal-confirm-button-2').append(Lang[config.lang]['confim_sell_confirm_button']);
		$('#income-expenses-p').empty();
		$('#income-expenses-p').append(Lang[config.lang]['str_income_expenses']);

		$('#span-main-page').empty();
		$('#span-main-page').append(Lang[config.lang]['str_main_page_title_navbar']);
		$('#span-goods-page').empty();
		$('#span-goods-page').append(Lang[config.lang]['str_goods_page_title_navbar']);
		$('#span-jobs-page').empty();
		$('#span-jobs-page').append(Lang[config.lang]['str_jobs_page_title_navbar']);
		$('#span-hire-page').empty();
		$('#span-hire-page').append(Lang[config.lang]['str_hire_page_title_navbar']);
		$('#span-upgrades-page').empty();
		$('#span-upgrades-page').append(Lang[config.lang]['str_upgrades_page_title_navbar']);
		$('#span-bank-page').empty();
		$('#span-bank-page').append(Lang[config.lang]['str_bank_page_title_navbar']);
		$('#span-sell-page').empty();
		$('#span-sell-page').append(Lang[config.lang]['str_sell_page_title_navbar']);

		$('#main-page-title').empty();
		$('#main-page-title').append(Lang[config.lang]['str_main_page_title']);
		$('#main-page-desc').empty();
		$('#main-page-desc').append(Lang[config.lang]['str_main_page_desc']);
		$('#profile-money-earned-2').empty();
		$('#profile-money-earned-2').append(Lang[config.lang]['str_main_page_money_earned']);
		$('#profile-money-spent-2').empty();
		$('#profile-money-spent-2').append(Lang[config.lang]['str_main_page_money_spent']);
		$('#profile-goods-2').empty();
		$('#profile-goods-2').append(Lang[config.lang]['str_main_page_goods']);
		$('#profile-distance-traveled-2').empty();
		$('#profile-distance-traveled-2').append(Lang[config.lang]['str_main_page_distance_traveled']);
		$('#profile-total-visits-2').empty();
		$('#profile-total-visits-2').append(Lang[config.lang]['str_main_page_total_visits']);
		$('#profile-customers-2').empty();
		$('#profile-customers-2').append(Lang[config.lang]['str_main_page_customers']);

		$('#goods-page-title').empty();
		$('#goods-page-title').append(Lang[config.lang]['str_goods_page_title']);
		$('#goods-page-desc').empty();
		$('#goods-page-desc').append(Lang[config.lang]['str_goods_page_desc']);

		$('#jobs-page-title').empty();
		$('#jobs-page-title').append(Lang[config.lang]['str_jobs_page_title']);
		$('#jobs-page-desc').empty();
		$('#jobs-page-desc').append(Lang[config.lang]['str_jobs_page_desc']);

		$('#hire-page-title').empty();
		$('#hire-page-title').append(Lang[config.lang]['str_hire_page_title']);
		$('#hire-page-desc').empty();
		$('#hire-page-desc').append(Lang[config.lang]['str_hire_page_desc']);
		$('#hire-page-form').empty();
		$('#hire-page-form').append(`
			<div class="col-4">
				<input id="form_name" type="text" name="name" class="form-control" placeholder="` + Lang[config.lang]['str_hire_page_form_job_name'] + `" required="required" oninput="InvalidMsg(this);" oninvalid="InvalidMsg(this);"> 
			</div>
			<div class="col-3">
				<input id="form_reward" type="number" min="1" name="reward" class="form-control" placeholder="` + Lang[config.lang]['str_hire_page_form_reward'] + `" required="required" oninput="InvalidMsg(this,1);" oninvalid="InvalidMsg(this,1);"> 
			</div>
			<div class="col-3" id="form_amount">
				<input type="number" min="1" name="amount" class="form-control" placeholder="` + Lang[config.lang]['str_hire_page_form_amount'] + `" required="required"> 
			</div>
			<div class="col-2"> 
				<button class="btn btn-blue btn-darken-2 btn-send btn-block white">` + Lang[config.lang]['btn_hire_page_form'] + `</button>
			</div>
		`);

		$('#upgrades-page-title').empty();
		$('#upgrades-page-title').append(Lang[config.lang]['str_upgrades_page_title']);
		$('#upgrades-page-desc').empty();
		$('#upgrades-page-desc').append(Lang[config.lang]['str_upgrades_page_desc']);

		$('#bank-page-title').empty();
		$('#bank-page-title').append(Lang[config.lang]['str_bank_page_title']);
		$('#bank-page-desc').empty();
		$('#bank-page-desc').append(Lang[config.lang]['str_bank_page_desc']);
		$('#bank-page-withdraw').empty();
		$('#bank-page-withdraw').append(Lang[config.lang]['str_bank_page_withdraw']);
		$('#bank-page-deposit').empty();
		$('#bank-page-deposit').append(`
			<input id="input-deposit-money" class="deposit-money" type="number" placeholder="` + Lang[config.lang]['str_amount'] + `">
			<button onclick="depositMoney()" class="btn btn-blue btn-darken-2 white deposit-money-btn">` + Lang[config.lang]['btn_bank_page_deposit'] + `</button>
		`);

		$("form").submit(function(e){
			e.preventDefault();
		});
	}
	if (item.hidemenu){
		$(".main").css("display", "none");
	}
});


/*=================
	FUNCTIONS
=================*/

function openPage(pageN){
	if(pageN == 0){
		$(".pages").css("display", "none");
		$(".main-page").css("display", "block");
	}
	if(pageN == 1){
		$(".pages").css("display", "none");
		$(".goods-page").css("display", "block");
	}
	if(pageN == 2){
		$(".pages").css("display", "none");
		$(".jobs-page").css("display", "block");
	}
	if(pageN == 3){
		$(".pages").css("display", "none");
		$(".hire-page").css("display", "block");
	}
	if(pageN == 4){
		$(".pages").css("display", "none");
		$(".upgrades-page").css("display", "block");
	}
	if(pageN == 5){
		$(".pages").css("display", "none");
		$(".bank-page").css("display", "block");
	}
}

function getStarsHTML(value){
	var html = "";
	for (var i = 1; i <= 5; i++) {
		if(i <= value){
			html += '<li class="list-inline-item m-1"><i class="fa fa-star amber font-large-1"></i></li>';
		}else{
			html += '<li class="list-inline-item m-1"><i class="fa fa-star-o amber font-large-1"></i></li>';
		}
	}
	return html;
}

document.onkeyup = function(data){
	if (data.which == 27){
		if ($("body").is(":visible")){
	$("#buyModal").modal('hide');
			post("close","")
		}
	}
};

$('.sidebar-navigation ul li').on('click', function() {
	$('li').removeClass('active');
	$(this).addClass('active');
});


function timeConverter(UNIX_timestamp,locale){
	var a = new Date(UNIX_timestamp * 1000);
	var time = a.toLocaleString(locale);
	return time;
}

function InvalidMsg(textbox,min,max) {
	
	if (textbox.value == '') {
		textbox.setCustomValidity(Lang[config.lang]['str_fill_field']);
	}
	else if(textbox.validity.typeMismatch){
		textbox.setCustomValidity(Lang[config.lang]['str_invalid_value']);
	}
	else if(textbox.validity.rangeUnderflow){
		textbox.setCustomValidity(Lang[config.lang]['str_more_than'].format(min));
	}
	else if(textbox.validity.rangeOverflow){
		textbox.setCustomValidity(Lang[config.lang]['str_less_than'].format(max));
	}
	else {
		textbox.setCustomValidity('');
	}
	return true;
}

$('#buyModal').on('hidden.bs.modal', function () {
	closeUI();
})

if (!String.prototype.format) {
String.prototype.format = function() {
	var args = arguments;
	return this.replace(/{(\d+)}/g, function(match, number) { 
	return typeof args[number] != 'undefined'
		? args[number]
		: match
	;
	});
};
}

function log(d){
	console.log(JSON.stringify(d));
}

/*=================
	CALLBACKS
=================*/

function closeUI(){
	post("close","")
}
function startJob(type,ressuply_id){
	post("startJob",{type:type,ressuply_id:ressuply_id})
}
$(document).ready( function() { // Submitted create job form
	$("#contact-form").on('submit', function(e){
		e.preventDefault();
		var form = $('#contact-form').serializeArray();
		post("createJob",{name:form[0].value,reward:form[1].value,amount:form[2].value})
	});
})

function deleteJob(job_id){
	post("deleteJob",{job_id:job_id})
}
function buyUpgrade(id){
	post("buyUpgrade",{id:id})
}
function depositMoney(){
	var amount = document.getElementById('input-deposit-money').value;
	document.getElementById('input-deposit-money').value = null;
	post("depositMoney",{amount:amount})
}
function withdrawMoney(){
	post("withdrawMoney",{})
}
function buyMarket(){
	post("buyMarket",{})
}
function sellMarket(){
	post("sellMarket",{})
}
function applyPrice(){
	var controlBox = document.getElementsByClassName("control-box")[0];
	var cbSlider = controlBox.querySelector("input.slider");
	var value = parseInt(cbSlider.value);
	post("applyPrice",{value:value})
}

function post(name,data){
	$.post("http://esx_gas_station/"+name,JSON.stringify(data),function(datab){
		if (datab != "ok"){
			console.log(datab);
		}
	});
}


/**
 * Javascript Fluid Meter
 * by Angel Arcoraci
 * https://github.com/aarcoraci
 * 
 * MIT License
 */

function FluidMeter() {
var context;
var targetContainer;

var time = null;
var dt = null;

var options = {
	drawShadow: true,
	drawText: true,
	drawPercentageSign: true,
	drawBubbles: true,
	bubbleAmount: 0,
	fontSize: "70px",
	fontFamily: "Arial",
	fontFillStyle: "white",
	size: 300,
	borderWidth: 25,
	backgroundColor: "#e2e2e2",
	foregroundColor: "#fafafa"
};

var currentFillPercentage = 0;
var fillPercentage = 0;

//#region fluid context values
var foregroundFluidLayer = {
	fillStyle: "purple",
	angle: 0,
	horizontalPosition: 0,
	angularSpeed: 0,
	maxAmplitude: 9,
	frequency: 30,
	horizontalSpeed: -150,
	initialHeight: 0
};

var backgroundFluidLayer = {
	fillStyle: "pink",
	angle: 0,
	horizontalPosition: 0,
	angularSpeed: 140,
	maxAmplitude: 12,
	frequency: 40,
	horizontalSpeed: 150,
	initialHeight: 0
};

var bubblesLayer = {
	bubbles: [],
	speed: 20,
	current: 0,
	swing: 0,
	size: 2,
	reset: function (bubble) {
	// calculate the area where to spawn the bubble based on the fluid area
	var meterBottom = (options.size - (options.size - getMeterRadius()) / 2) - options.borderWidth;
	var fluidAmount = currentFillPercentage * (getMeterRadius() - options.borderWidth * 2) / 100;

	bubble.r = random(this.size, this.size * 2) / 2;
	bubble.x = random(0, options.size);
	bubble.y = random(meterBottom, meterBottom - fluidAmount);
	bubble.velX = 0;
	bubble.velY = random(this.speed, this.speed * 2);
	bubble.swing = random(0, 2 * Math.PI);
	},
	init() {
	for (var i = 0; i < options.bubbleAmount; i++) {

		var meterBottom = (options.size - (options.size - getMeterRadius()) / 2) - options.borderWidth;
		var fluidAmount = currentFillPercentage * (getMeterRadius() - options.borderWidth * 2) / 100;
		this.bubbles.push({
		x: random(0, options.size),
		y: random(meterBottom, meterBottom - fluidAmount),
		r: random(this.size, this.size * 2) / 2,
		velX: 0,
		velY: random(this.speed, this.speed * 2)
		});
	}
	}
}
//#endregion

/**
 * initializes and mount the canvas element on the document
 */
function setupCanvas() {
	var canvas = document.createElement('canvas');
	canvas.width = options.size;
	canvas.height = options.size;
	canvas.imageSmoothingEnabled = true;
	context = canvas.getContext("2d");
	targetContainer.appendChild(canvas);

	// shadow is not required  to be on the draw loop
	//#region shadow
	if (options.drawShadow) {
	context.save();
	context.beginPath();
	context.filter = "drop-shadow(0px 4px 6px rgba(0,0,0,0.1))";
	context.arc(options.size / 2, options.size / 2, getMeterRadius() / 2, 0, 2 * Math.PI);
	context.closePath();
	context.fill();
	context.restore();
	}
	//#endregion
}

/**
 * draw cycle
 */
function draw() {
	var now = new Date().getTime();
	dt = (now - (time || now)) / 1000;
	time = now;

	requestAnimationFrame(draw);
	context.clearRect(0, 0, options.width, options.height);
	drawMeterBackground();
	drawFluid(dt);
	if (options.drawText) {
	drawText();
	}
	drawMeterForeground();
}

function drawMeterBackground() {
	context.save();
	context.fillStyle = options.backgroundColor;
	context.beginPath();
	context.arc(options.size / 2, options.size / 2, getMeterRadius() / 2 - options.borderWidth, 0, 2 * Math.PI);
	context.closePath();
	context.fill();
	context.restore();
}

function drawMeterForeground() {
	context.save();
	context.lineWidth = options.borderWidth;
	context.strokeStyle = options.foregroundColor;
	context.beginPath();
	context.arc(options.size / 2, options.size / 2, getMeterRadius() / 2 - options.borderWidth / 2, 0, 2 * Math.PI);
	context.closePath();
	context.stroke();
	context.restore();
}
/**
 * draws the fluid contents of the meter
 * @param  {} dt elapsed time since last frame
 */
function drawFluid(dt) {
	context.save();
	context.arc(options.size / 2, options.size / 2, getMeterRadius() / 2 - options.borderWidth, 0, Math.PI * 2);
	context.clip();
	drawFluidLayer(backgroundFluidLayer, dt);
	drawFluidLayer(foregroundFluidLayer, dt);
	if (options.drawBubbles) {
	drawFluidMask(foregroundFluidLayer, dt);
	drawBubblesLayer(dt);
	}
	context.restore();
}


/**
 * draws the foreground fluid layer
 * @param  {} dt elapsed time since last frame
 */
function drawFluidLayer(layer, dt) {
	// calculate wave angle
	if (layer.angularSpeed > 0) {
	layer.angle += layer.angularSpeed * dt;
	layer.angle = layer.angle < 0 ? layer.angle + 360 : layer.angle;
	}

	// calculate horizontal position
	layer.horizontalPosition += layer.horizontalSpeed * dt;
	if (layer.horizontalSpeed > 0) {
	layer.horizontalPosition > Math.pow(2, 53) ? 0 : layer.horizontalPosition;
	}
	else if (layer.horizontalPosition < 0) {
	layer.horizontalPosition < -1 * Math.pow(2, 53) ? 0 : layer.horizontalPosition;
	}

	var x = 0;
	var y = 0;
	var amplitude = layer.maxAmplitude * Math.sin(layer.angle * Math.PI / 180);

	var meterBottom = (options.size - (options.size - getMeterRadius()) / 2) - options.borderWidth;
	var fluidAmount = currentFillPercentage * (getMeterRadius() - options.borderWidth * 2) / 100;

	if (currentFillPercentage < fillPercentage) {
	currentFillPercentage += 15 * dt;
	} else if (currentFillPercentage > fillPercentage) {
	currentFillPercentage -= 15 * dt;
	}

	layer.initialHeight = meterBottom - fluidAmount;

	context.save();
	context.beginPath();

	context.lineTo(0, layer.initialHeight);

	while (x < options.size) {
	y = layer.initialHeight + amplitude * Math.sin((x + layer.horizontalPosition) / layer.frequency);
	context.lineTo(x, y);
	x++;
	}

	context.lineTo(x, options.size);
	context.lineTo(0, options.size);
	context.closePath();

	context.fillStyle = layer.fillStyle;
	context.fill();
	context.restore();
}

/**
 * clipping mask for objects within the fluid constrains
 * @param {Object} layer layer to be used as a mask
 */
function drawFluidMask(layer) {
	var x = 0;
	var y = 0;
	var amplitude = layer.maxAmplitude * Math.sin(layer.angle * Math.PI / 180);

	context.beginPath();

	context.lineTo(0, layer.initialHeight);

	while (x < options.size) {
	y = layer.initialHeight + amplitude * Math.sin((x + layer.horizontalPosition) / layer.frequency);
	context.lineTo(x, y);
	x++;
	}
	context.lineTo(x, options.size);
	context.lineTo(0, options.size);
	context.closePath();
	context.clip();
}

function drawBubblesLayer(dt) {
	context.save();
	for (var i = 0; i < bubblesLayer.bubbles.length; i++) {
	var bubble = bubblesLayer.bubbles[i];

	context.beginPath();
	context.strokeStyle = 'white';
	context.arc(bubble.x, bubble.y, bubble.r, 2 * Math.PI, false);
	context.stroke();
	context.closePath();

	var currentSpeed = bubblesLayer.current * dt;

	bubble.velX = Math.abs(bubble.velX) < Math.abs(bubblesLayer.current) ? bubble.velX + currentSpeed : bubblesLayer.current;
	bubble.y = bubble.y - bubble.velY * dt;
	bubble.x = bubble.x + (bubblesLayer.swing ? 0.4 * Math.cos(bubblesLayer.swing += 0.03) * bubblesLayer.swing : 0) + bubble.velX * 0.5;

	// determine if current bubble is outside the safe area
	var meterBottom = (options.size - (options.size - getMeterRadius()) / 2) - options.borderWidth;
	var fluidAmount = currentFillPercentage * (getMeterRadius() - options.borderWidth * 2) / 100;

	if (bubble.y <= meterBottom - fluidAmount) {
		bubblesLayer.reset(bubble);
	}

	}
	context.restore();
}

function drawText() {

	var text = options.drawPercentageSign ?
	currentFillPercentage.toFixed(0) + "%" : currentFillPercentage.toFixed(0);

	context.save();
	context.font = getFontSize();
	context.fillStyle = options.fontFillStyle;
	context.textAlign = "center";
	context.textBaseline = 'middle';
	context.filter = "drop-shadow(0px 0px 5px rgba(0,0,0,0.4))"
	context.fillText(text, options.size / 2, options.size / 2);
	context.restore();
}

//#region helper methods
function clamp(number, min, max) {
	return Math.min(Math.max(number, min), max);
};
function getMeterRadius() {
	return options.size * 0.9;
}

function random(min, max) {
	var delta = max - min;
	return max === min ? min : Math.random() * delta + min;
}

function getFontSize() {
	return options.fontSize + " " + options.fontFamily;
}
//#endregion

return {
	init: function (env) {
	if (!env.targetContainer)
		throw "empty or invalid container";

	targetContainer = env.targetContainer;
	fillPercentage = clamp(env.fillPercentage, 0, 100);
	if (env.options) {
		options.drawShadow = env.options.drawShadow === false ? false : true;
		options.size = env.options.size;
		options.drawBubbles = env.options.drawBubbles === false ? false : true;
		options.borderWidth = env.options.borderWidth || options.borderWidth;
		options.foregroundFluidColor = env.options.foregroundFluidColor || options.foregroundFluidColor;
		options.backgroundFluidColor = env.options.backgroundFluidColor || options.backgroundFluidColor;
		options.backgroundColor = env.options.backgroundColor || options.backgroundColor;
		options.foregroundColor = env.options.foregroundColor || options.foregroundColor;

		options.drawText = env.options.drawText === false ? false : true;
		options.drawPercentageSign = env.options.drawPercentageSign === false ? false : true;
		options.bubbleAmount = Math.round(env.options.bubbleAmount) || options.bubbleAmount;
		options.fontSize = env.options.fontSize || options.fontSize;
		options.fontFamily = env.options.fontFamily || options.fontFamily;
		options.fontFillStyle = env.options.fontFillStyle || options.fontFillStyle;
		// fluid settings

		if (env.options.foregroundFluidLayer) {
		foregroundFluidLayer.fillStyle = env.options.foregroundFluidLayer.fillStyle || foregroundFluidLayer.fillStyle;
		foregroundFluidLayer.angularSpeed = env.options.foregroundFluidLayer.angularSpeed || foregroundFluidLayer.angularSpeed;
		foregroundFluidLayer.maxAmplitude = env.options.foregroundFluidLayer.maxAmplitude || foregroundFluidLayer.maxAmplitude;
		foregroundFluidLayer.frequency = env.options.foregroundFluidLayer.frequency || foregroundFluidLayer.frequency;
		foregroundFluidLayer.horizontalSpeed = env.options.foregroundFluidLayer.horizontalSpeed || foregroundFluidLayer.horizontalSpeed;
		}

		if (env.options.backgroundFluidLayer) {
		backgroundFluidLayer.fillStyle = env.options.backgroundFluidLayer.fillStyle || backgroundFluidLayer.fillStyle;
		backgroundFluidLayer.angularSpeed = env.options.backgroundFluidLayer.angularSpeed || backgroundFluidLayer.angularSpeed;
		backgroundFluidLayer.maxAmplitude = env.options.backgroundFluidLayer.maxAmplitude || backgroundFluidLayer.maxAmplitude;
		backgroundFluidLayer.frequency = env.options.backgroundFluidLayer.frequency || backgroundFluidLayer.frequency;
		backgroundFluidLayer.horizontalSpeed = env.options.backgroundFluidLayer.horizontalSpeed || backgroundFluidLayer.horizontalSpeed;
		}
	}



	bubblesLayer.init();
	setupCanvas();
	draw();
	},
	setPercentage(percentage) {

	fillPercentage = clamp(percentage, 0, 100);
	}
}
};

(() => {
	const toastPosition = {
		TopLeft: "top-left",
		TopCenter: "top-center",
		TopRight: "top-right",
		BottomLeft: "bottom-left",
		BottomCenter: "bottom-center",
		BottomRight: "bottom-right"
	}

	const toastPositionIndex = [
		[toastPosition.TopLeft, toastPosition.TopCenter, toastPosition.TopRight],
		[toastPosition.BottomLeft, toastPosition.BottomCenter, toastPosition.BottomRight]
	]

	const svgs = {
		successo: '<svg viewBox="0 0 426.667 426.667" width="18" height="18"><path d="M213.333 0C95.518 0 0 95.514 0 213.333s95.518 213.333 213.333 213.333c117.828 0 213.333-95.514 213.333-213.333S331.157 0 213.333 0zm-39.134 322.918l-93.935-93.931 31.309-31.309 62.626 62.622 140.894-140.898 31.309 31.309-172.203 172.207z" fill="#6ac259"></path></svg>',
		aviso: '<svg viewBox="0 0 310.285 310.285" width=18 height=18> <path d="M264.845 45.441C235.542 16.139 196.583 0 155.142 0 113.702 0 74.743 16.139 45.44 45.441 16.138 74.743 0 113.703 0 155.144c0 41.439 16.138 80.399 45.44 109.701 29.303 29.303 68.262 45.44 109.702 45.44s80.399-16.138 109.702-45.44c29.303-29.302 45.44-68.262 45.44-109.701.001-41.441-16.137-80.401-45.439-109.703zm-132.673 3.895a12.587 12.587 0 0 1 9.119-3.873h28.04c3.482 0 6.72 1.403 9.114 3.888 2.395 2.485 3.643 5.804 3.514 9.284l-4.634 104.895c-.263 7.102-6.26 12.933-13.368 12.933H146.33c-7.112 0-13.099-5.839-13.345-12.945L128.64 58.594c-.121-3.48 1.133-6.773 3.532-9.258zm23.306 219.444c-16.266 0-28.532-12.844-28.532-29.876 0-17.223 12.122-30.211 28.196-30.211 16.602 0 28.196 12.423 28.196 30.211.001 17.591-11.456 29.876-27.86 29.876z" fill="#FFDA44" /> </svg>',
		importante: '<svg viewBox="0 0 23.625 23.625" width=18 height=18> <path d="M11.812 0C5.289 0 0 5.289 0 11.812s5.289 11.813 11.812 11.813 11.813-5.29 11.813-11.813S18.335 0 11.812 0zm2.459 18.307c-.608.24-1.092.422-1.455.548a3.838 3.838 0 0 1-1.262.189c-.736 0-1.309-.18-1.717-.539s-.611-.814-.611-1.367c0-.215.015-.435.045-.659a8.23 8.23 0 0 1 .147-.759l.761-2.688c.067-.258.125-.503.171-.731.046-.23.068-.441.068-.633 0-.342-.071-.582-.212-.717-.143-.135-.412-.201-.813-.201-.196 0-.398.029-.605.09-.205.063-.383.12-.529.176l.201-.828c.498-.203.975-.377 1.43-.521a4.225 4.225 0 0 1 1.29-.218c.731 0 1.295.178 1.692.53.395.353.594.812.594 1.376 0 .117-.014.323-.041.617a4.129 4.129 0 0 1-.152.811l-.757 2.68a7.582 7.582 0 0 0-.167.736 3.892 3.892 0 0 0-.073.626c0 .356.079.599.239.728.158.129.435.194.827.194.185 0 .392-.033.626-.097.232-.064.4-.121.506-.17l-.203.827zm-.134-10.878a1.807 1.807 0 0 1-1.275.492c-.496 0-.924-.164-1.28-.492a1.57 1.57 0 0 1-.533-1.193c0-.465.18-.865.533-1.196a1.812 1.812 0 0 1 1.28-.497c.497 0 .923.165 1.275.497.353.331.53.731.53 1.196 0 .467-.177.865-.53 1.193z" fill="#006DF0" /> </svg>',
		erro: '<svg viewBox="0 0 51.976 51.976" width=18 height=18> <path d="M44.373 7.603c-10.137-10.137-26.632-10.138-36.77 0-10.138 10.138-10.137 26.632 0 36.77s26.632 10.138 36.77 0c10.137-10.138 10.137-26.633 0-36.77zm-8.132 28.638a2 2 0 0 1-2.828 0l-7.425-7.425-7.778 7.778a2 2 0 1 1-2.828-2.828l7.778-7.778-7.425-7.425a2 2 0 1 1 2.828-2.828l7.425 7.425 7.071-7.071a2 2 0 1 1 2.828 2.828l-7.071 7.071 7.425 7.425a2 2 0 0 1 0 2.828z" fill="#D80027" /> </svg>'
	}

	const styles = `
		.vt-container {
			position: fixed;
			width: 100%;
			height: 100vh;
			top: 0;
			left: 0;
			z-index: 9999;
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			pointer-events: none;
		}

		.vt-row {
			display: flex;
			justify-content: space-between;
		}

		.vt-col {
			flex: 1;
			margin: 10px 20px;
			display: flex;
			flex-direction: column;
			align-items: center;
		}

		.vt-col.top-left,
		.vt-col.bottom-left {
			align-items: flex-start;
		}

		.vt-col.top-right,
		.vt-col.bottom-right {
			align-items: flex-end;
		}

		.vt-card {
			display: flex;
			justify-content: center;
			align-items: center;
			padding: 12px 20px;
			background-color: #fff;
			box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
			color: #000;
			border-radius: 4px;
			margin: 0px;
			transition: 0.3s all ease-in-out;
			pointer-events: all;
			border-left: 3px solid #8b8b8b;
			cursor: pointer;
		}

		.vt-card.successo {
			border-left: 3px solid #6ec05f;
		}

		.vt-card.aviso {
			border-left: 3px solid #fed953;
		}

		.vt-card.importante {
			border-left: 3px solid #1271ec;
		}

		.vt-card.erro {
			border-left: 3px solid #d60a2e;
		}

		.vt-card .text-group {
			margin-left: 15px;
		}

		.vt-card h4 {
			margin: 0;
			margin-bottom: 10px;
			font-size: 16px;
			font-weight: 500;
		}

		.vt-card p {
			margin: 0;
			font-size: 14px;
		}
	`

	const styleSheet = document.createElement("style")
	styleSheet.innerText = styles.replace((/  |\r\n|\n|\r/gm), "")
	document.head.appendChild(styleSheet)

	const vtContainer = document.createElement("div")
	vtContainer.className = "vt-container"

	for (const ri of [0, 1]) {
		const row = document.createElement("div")
		row.className = "vt-row"

		for (const ci of [0, 1, 2]) {
			const col = document.createElement("div")
			col.className = `vt-col ${toastPositionIndex[ri][ci]}`

			row.appendChild(col)
		}

		vtContainer.appendChild(row)
	}

	document.body.appendChild(vtContainer)

	window.vt = {
		options: {
			title: undefined,
			position: toastPosition.TopCenter,
			duration: 10000,
			closable: true,
			focusable: true,
			callback: undefined
		},
		successo(message, options) {
			show(message, options, "successo")
		},
		importante(message, options) {
			show(message, options, "importante")
		},
		aviso(message, options) {
			show(message, options, "aviso")
		},
		erro(message, options) {
			show(message, options, "erro")
		}
	}

	function show(message = "", options, type) {
		options = { ...window.vt.options, ...options }

		const col = document.getElementsByClassName(options.position)[0]

		const vtCard = document.createElement("div")
		vtCard.className = `vt-card ${type}`
		vtCard.innerHTML += svgs[type]
		vtCard.options = {
			...options, ...{
				message,
				type: type,
				yPos: options.position.indexOf("top") > -1 ? "top" : "bottom",
				isFocus: false
			}
		}

		setVTCardContent(vtCard)
		setVTCardIntroAnim(vtCard)
		setVTCardBindEvents(vtCard)
		autoDestroy(vtCard)

		

		col.appendChild(vtCard)
	}

	function setVTCardContent(vtCard) {
		const textGroupDiv = document.createElement("div")

		textGroupDiv.className = "text-group"

		if (vtCard.options.title) {
			textGroupDiv.innerHTML = `<h4>${vtCard.options.title}</h4>`
		}

		textGroupDiv.innerHTML += `<p>${vtCard.options.message}</p>`

		vtCard.appendChild(textGroupDiv)
	}

	function setVTCardIntroAnim(vtCard) {
		vtCard.style.setProperty(`margin-${vtCard.options.yPos}`, "-15px")
		vtCard.style.setProperty("opacity", "0")

		setTimeout(() => {
			vtCard.style.setProperty(`margin-${vtCard.options.yPos}`, "15px")
			vtCard.style.setProperty("opacity", "1")
		}, 50)
	}

	function setVTCardBindEvents(vtCard) {
		vtCard.addEventListener("click", () => {
			if (vtCard.options.closable) {
				destroy(vtCard)
			}
		})

		vtCard.addEventListener("mouseover", () => {
			vtCard.options.isFocus = vtCard.options.focusable
		})

		vtCard.addEventListener("mouseout", () => {
			vtCard.options.isFocus = false
			autoDestroy(vtCard, vtCard.options.duration)
		})
	}

	function destroy(vtCard) {
		vtCard.style.setProperty(`margin-${vtCard.options.yPos}`, `-${vtCard.offsetHeight}px`)
		vtCard.style.setProperty("opacity", "0")

		setTimeout(() => {
			if(typeof x !== "undefined"){
				vtCard.parentNode.removeChild(v)

				if (typeof vtCard.options.callback === "function") {
					vtCard.options.callback()
				}
			}
		}, 500)
	}

	function autoDestroy(vtCard) {
		if (vtCard.options.duration !== 0) {
			setTimeout(() => {
				if (!vtCard.options.isFocus) {
					destroy(vtCard)
				}
			}, vtCard.options.duration)
		}
	}
})()