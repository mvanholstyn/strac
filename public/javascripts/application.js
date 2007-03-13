function toggle_hide_show_with_smart_loading( id_to_show, ids_to_hide ) {
	id_to_show = $(id_to_show);
	if( id_to_show.visible() ) {
		new Effect.BlindUp( id_to_show, { duration: 0.3 } );
		return false;
	} else if( id_to_show.innerHTML != '' ) {
		ids_to_hide.each( 
			function( id_to_hide ) { 
				new Effect.BlindUp( id_to_hide, { duration: 0.3 } ); 
			}
		);
		
		new Effect.Parallel(
			[	new Effect.BlindDown( id_to_show, { sync: true } ), 
				new Effect.ScrollPage( id_to_show, { syne: true } ) ],
			{ duration: 0.3 }
		);
		
		if( arguments[2] ) {
			Selector.findChildElements( id_to_show, $A( [ "form" ] ) ).each( 
				function( form ) { 
					setTimeout( 
						function() { 
							form.focusFirstElement(); 
						}, 500 ); 
					}
			);
		}
		return false;
	}
	return true;
}


Effect.ScrollPage = Class.create();
Object.extend(Object.extend(Effect.ScrollPage.prototype, Effect.Base.prototype), {
	initialize: function(element) {
		this.element = $(element);
		this.start(arguments[1] || {});
	},
	update: function(position) {
		var window_top =  window.pageYOffset
				|| document.documentElement.scrollTop
				|| document.body.scrollTop
				|| 0;

		var window_height = window.innerHeight
			|| document.body.innerHeight
			|| 0;

		var element_top = Position.cumulativeOffset( this.element )[1];
		var element_height = this.element.getHeight();

		var y_target = ( element_top + element_height ) - window_height;
		
		if( element_top + element_height > window_top + window_height ) {
			if( Position.cumulativeOffset( this.element.parentNode )[1] < y_target ) {
				y_target = Position.cumulativeOffset( this.element.parentNode )[1];
			}
			window.scrollTo( 0, y_target );
		}
	}
});