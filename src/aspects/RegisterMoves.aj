package aspects;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

import core.Player;
import core.model.Grid;
import core.model.Spot;
import javafx.stage.Stage;
import ui.App;
import ui.Borad;

public aspect RegisterMoves {
	
	File mFile;
	
	public ArrayList<String> Player.mMoves = new ArrayList<String> ();
	
	pointcut notifyStart(App app, Stage primaryStage) : execution (void start(Stage)) && args (primaryStage) && target (app);

	/**
	 * Create a new file when the game start to store the moves of the new game
	 * @param app
	 * @param primaryStage
	 */
	before(App app, Stage primaryStage) : notifyStart(app, primaryStage) { 
		String fileName;
		File file;
		for(int i = 0 ; i < 100 ; i++) {
			fileName = "Moves_" + i + ".txt";
			file = new File(fileName);
	
			try {
				// if file doesn't exists, then create it
				if (!file.exists()) {
					file.createNewFile();
					mFile = file;
					return;
				}
	
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	} 
	
	pointcut registerMove(Borad board, Spot place) : execution (* ui.Borad.stonePlaced (Spot)) && args (place) && target (board);

	/**
	 * Register the new move in file with player's name and location
	 * @param app
	 * @param place
	 */
	before(Borad board, Spot place) : registerMove(board, place) {
		if (place.getOccupant().getName() == "Winner")
			return;
		
		String str = place.getOccupant().getName();
		str += " : ";
		str += place.toString();
		
		try (FileOutputStream fop = new FileOutputStream(mFile, true)) {

			// if file doesn't exists, then create it
			if (!mFile.exists()) {
				mFile.createNewFile();
			}

			// get the content in bytes
			byte[] contentInBytes = str.getBytes();

			fop.write(contentInBytes);
			fop.write("\n".getBytes()); //Be aware that \n doesn't work with the windows "Bloc-note"
			fop.flush();
			fop.close();

			System.out.println("Done");

		} catch (IOException e) {
			e.printStackTrace();
		}

		/* Register Player move in his list */		
		place.getOccupant().mMoves.add (place.toString());
		
		System.out.println("Après le move : " + str); 
	} 
	
	pointcut lastRegister(Grid grid, Player player) : call (void notifyGameOver(Player)) && args (player) && target (grid) && within(Grid);

	/**
	 * Register at the end of the game the moves list of each player
	 * @param app
	 * @param primaryStage
	 */
	after(Grid grid, Player player) : lastRegister(grid, player) {	
		String str = "\n";
		for(Player p : App.getPlayers()) {
			str += p.getName() + " :\n";
			for (String moveStr : p.mMoves) {
				str += moveStr + "\n";
			}
			str += "\n";
		}
		
		try (FileOutputStream fop = new FileOutputStream(mFile, true)) {

			// if file doesn't exists, then create it
			if (!mFile.exists()) {
				mFile.createNewFile();
			}

			// get the content in bytes
			byte[] contentInBytes = str.getBytes();

			fop.write(contentInBytes);
			fop.write("\n".getBytes()); //Be aware that \n doesn't work with the windows "Bloc-note"
			fop.flush();
			fop.close();

			System.out.println("Done");

		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
}
