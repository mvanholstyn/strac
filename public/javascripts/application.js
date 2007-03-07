function toggle_hide_show_with_smart_loading( id_to_show, ids_to_hide ) {
	if( $(id_to_show).visible() ) {
		new Effect.BlindUp( id_to_show, { duration: 0.3 } );
		return false;
	} else if( $(id_to_show).innerHTML != '' ) {
		ids_to_hide.each( 
			function( id_to_hide ) { 
				new Effect.BlindUp( id_to_hide, { duration: 0.3 } ); 
			}
		);
		new Effect.BlindDown( id_to_show, { duration: 0.3 } );
		return false;
	}
	return true;
}