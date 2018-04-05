package aspects;

import java.util.ArrayList;

import core.Player;
import core.model.Grid;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import ui.App;

public aspect AdversaireJ {
	public static ArrayList<Player> App.mPlayers = new ArrayList<Player> ();
	public static ArrayList<Player> App.getPlayers (){
		return mPlayers;
	}
	private boolean mIsFirstPlayer;
	pointcut notifyStart(App app, Stage primaryStage) : execution (void start(Stage)) && args (primaryStage) && target (app);

	/**
	 * Create to player to assign them to the new moves
	 * @param app
	 * @param primaryStage
	 */
	before(App app, Stage primaryStage) : notifyStart(app, primaryStage) { 
		App.mPlayers.add(new Player ("Blue", Color.BLUE));
		App.mPlayers.add(new Player ("Red", Color.RED));
		
		mIsFirstPlayer = true;
	} 
	
	pointcut setPlayerToMove(Grid grid, int x, int y, Player player) : call (* core.model.Grid.placeStone (int, int, Player)) && args (x, y, player) && target (grid) && within (App);

	/**
	 * Set the current player in the spot before register in a file
	 * @param app
	 * @param place
	 */
	
	Object around(Grid grid, int x, int y, Player player) : setPlayerToMove (grid, x, y, player){
		int indexPlayer = 0;
		if (!mIsFirstPlayer) {
			indexPlayer = 1;
		}
		
		mIsFirstPlayer = !mIsFirstPlayer;
		
		return proceed(grid, x, y, App.mPlayers.get(indexPlayer));
		
	}
	
}
