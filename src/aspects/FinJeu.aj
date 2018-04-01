package aspects;

import java.util.List;

import core.GridChangeListener;
import core.Player;
import core.model.Grid;
import javafx.scene.paint.Color;
import core.model.Spot;

privileged public aspect FinJeu {

	public List<Spot> Grid.getWinningSpots (){
		return this.winningStones;
	}
	public List<GridChangeListener> Grid.getListeners (){
		return this.listeners;
	}
	public void Spot.ModifyOccupant (Player player){
		this.setOccupant (player);
	}
	
	pointcut notifyGameOver(Grid grid, Player player) : call (void notifyGameOver(Player)) && args (player) && target (grid) && within(Grid);

	/**
	 * Create a new file when the game start to store the moves of the new game
	 * @param app
	 * @param primaryStage
	 */
	after(Grid grid, Player player) : notifyGameOver(grid, player) {		
		Player winner = new Player ("Winner", Color.GOLD);

		List<Spot> spots = grid.getWinningSpots ();		
		for (Spot p : spots) {
			p.ModifyOccupant (winner);
			grid.notifyStonePlaced(p);
		}
		
		grid.getListeners ().clear();
		
	}
}
