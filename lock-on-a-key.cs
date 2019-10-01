// From https://stackoverflow.com/questions/6143279/how-do-i-synchronize-a-block-of-code-based-on-a-key
public class LockManager
{
	private readonly IDictionary<string, LockObject> _lockTable =
		new Dictionary<string, LockObject>();

	public void Work(string key, Action work)
	{
		var lockObject = BorrowLockObject(key);
		
		try
		{
			lock (lockObject)
			{
				work();
			}
		}
		finally
		{
			ReturnLockObject(lockObject);
		}
	}

	private LockObject BorrowLockObject(string key)
	{
		lock (_lockTable)
		{
			LockObject lockObject;

			if (_lockTable.ContainsKey(key))
			{
				lockObject = _lockTable[key];
			}
			else
			{
				lockObject = new LockObject(key);
				_lockTable[key] = lockObject;
			}

			lockObject.Open();

			return lockObject;
		}
	}

	private void ReturnLockObject(LockObject lockObject)
	{
		lock (_lockTable)
		{
			if (lockObject.Close())
			{
				_lockTable.Remove(lockObject.GetKey());
			}
		}
	}
}

// From https://stackoverflow.com/questions/6143279/how-do-i-synchronize-a-block-of-code-based-on-a-key
public class LockObject
{
	private readonly string _key;
	private int _count;

	public LockObject(string key)
	{
		_key = key;
		_count = 0;
	}

	public string GetKey()
	{
		return _key;
	}

	public void Open()
	{
		Interlocked.Increment(ref _count);
	}

	/// <summary>
	/// Closes this lock object.
	/// </summary>
	/// <returns>
	/// True if this Lock Object is no longer in use.
	/// </returns>
	public bool Close()
	{
		var safeCount = Interlocked.Decrement(ref _count);

		return safeCount == 0;
	}
}