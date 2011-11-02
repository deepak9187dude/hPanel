		//
		//  In my case I want to load them onload, this is how you do it!
		// 
		
		Event.observe(window, 'load', loadAccordions, false);

		//
		//	Set up all accordions
		//
		function loadAccordions() {
			
			var bottomAccordion = new accordion('vertical_container');
			
			var nestedVerticalAccordion = new accordion('vertical_nested_container', {
			  classNames : {
					toggle : 'vertical_accordion_toggle',
					toggleActive : 'vertical_accordion_toggle_active',
					content : 'vertical_accordion_content'
				}
			});
			
			// get the left id from querystring to know which menu should be open
			var post = document.railslft
			
			function querySt(ji) {
				hu = window.location.search.substring(1);
				gy = hu.split("&");
				for (i=0;i<gy.length;i++) {
					ft = gy[i].split("=");
					if (ft[0] == ji) {
						return ft[1];
					}
				}
				return 0;
			}
			

			// Open first one
			
			bottomAccordion.activate($$('#vertical_container .accordion_toggle')[post]);

			// Open second one

		}
		
